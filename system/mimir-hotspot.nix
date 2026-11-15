{ config, lib, pkgs, ... }:
let
  upstreamInterface = "wlan0";
  apInterface = "ap0";

  hotspotAddress = "192.168.50.1";
  hotspotPrefixLength = 24;
  hotspotDhcpRange = "192.168.50.10,192.168.50.100,255.255.255.0,12h";

  # Must match the transparent mode in system/mitmproxy.nix.
  transparentProxyPort = 28083;
in
{
  # One radio is shared between the upstream station interface (wlan0) and
  # the hotspot AP interface (ap0).
  networking.wireless.interfaces = [ upstreamInterface ];

  systemd.services.mimir-hotspot-ap0 = {
    description = "Create the virtual AP interface for the mimir hotspot";
    after = [ "sys-subsystem-net-devices-${upstreamInterface}.device" ];
    before = [
      "hostapd.service"
      "dnsmasq.service"
    ];
    partOf = [ "mimir-hotspot.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "mimir-hotspot-ap0" ''
        if ! ${pkgs.iproute2}/bin/ip link show ${apInterface} >/dev/null 2>&1; then
          ${pkgs.iw}/bin/iw dev ${upstreamInterface} interface add ${apInterface} type __ap
        fi
        ${pkgs.iproute2}/bin/ip addr replace ${hotspotAddress}/${toString hotspotPrefixLength} dev ${apInterface}
        ${pkgs.iproute2}/bin/ip link set ${apInterface} up
        ${config.systemd.package}/bin/udevadm settle --timeout=5 || true
      '';
      ExecStop = "-${pkgs.iproute2}/bin/ip link del ${apInterface}";
    };
  };

  services.hostapd = {
    enable = true;

    radios = {
      "${apInterface}" = {
        # Base values; preStart rewrites these to match the upstream STA.
        band = "2g";
        channel = 0;

        # 20 MHz only is much more reliable for concurrent AP+STA.
        wifi4 = {
          enable = true;
          capabilities = [ "SHORT-GI-20" ];
        };
        wifi5.enable = false;

        networks = {
          "${apInterface}" = {
            ssid = "mimir-hotspot";
            authentication = {
              mode = "wpa2-sha1";
              wpaPassword = "password";
            };
            settings.ieee80211w = 0;
          };
        };
      };
    };
  };

  systemd.services.hostapd = {
    # The hotspot is started on demand, not at boot.
    wantedBy = lib.mkForce [ ];
    partOf = [ "mimir-hotspot.target" ];
    requires = [ "mimir-hotspot-ap0.service" ];
    after = [ "mimir-hotspot-ap0.service" ];

    # The AP must use the same channel/band as the upstream station on a
    # single-radio AP+STA setup.
    preStart = lib.mkAfter ''
      cfg=/run/hostapd/${apInterface}.hostapd.conf

      channel=$(${pkgs.iw}/bin/iw dev ${upstreamInterface} info 2>/dev/null \
        | ${pkgs.gawk}/bin/awk '/^[[:space:]]*channel / { print $2; exit }' || true)
      freq=$(${pkgs.iw}/bin/iw dev ${upstreamInterface} info 2>/dev/null \
        | ${pkgs.gawk}/bin/awk '/^[[:space:]]*channel / { gsub(/[()]/, "", $4); print $4; exit }' || true)

      [ -n "$channel" ] && [ "$channel" != "0" ] || channel=6
      [ -n "$freq" ] || freq=2437

      if [ "$freq" -ge 5000 ]; then
        hw_mode=a
      else
        hw_mode=g
      fi

      ${pkgs.gnused}/bin/sed -i \
        -e "s/^hw_mode=.*/hw_mode=$hw_mode/" \
        -e "s/^channel=.*/channel=$channel/" \
        "$cfg"
    '';
  };

  services.dnsmasq = {
    enable = true;
    resolveLocalQueries = false;

    settings = {
      interface = apInterface;
      bind-dynamic = true;

      dhcp-range = hotspotDhcpRange;
      dhcp-option = [
        "3,${hotspotAddress}"
        "6,${hotspotAddress}"
      ];

      # Forward DNS to the local DNSCrypt resolver.
      server = [ "127.0.0.1#53" ];
      no-resolv = true;
      domain-needed = true;
      bogus-priv = true;
      dhcp-authoritative = true;
    };
  };

  systemd.services.dnsmasq = {
    # The DHCP/DNS server is started with the hotspot target.
    wantedBy = lib.mkForce [ ];
    partOf = [ "mimir-hotspot.target" ];
    requires = [ "mimir-hotspot-ap0.service" ];
    after = [ "mimir-hotspot-ap0.service" ];
  };

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv4.conf.all.send_redirects" = 0;
    "net.ipv4.conf.default.send_redirects" = 0;
  };

  networking.nat = {
    enable = true;
    internalInterfaces = [ apInterface ];
    externalInterface = upstreamInterface;

    extraCommands = ''
      # Transparent mitmproxy interception for hotspot HTTP/HTTPS.
      ${config.networking.firewall.package}/bin/iptables -w -t nat -A nixos-nat-pre \
        -i ${apInterface} -p tcp --dport 80 -j REDIRECT --to-ports ${toString transparentProxyPort}
      ${config.networking.firewall.package}/bin/iptables -w -t nat -A nixos-nat-pre \
        -i ${apInterface} -p tcp --dport 443 -j REDIRECT --to-ports ${toString transparentProxyPort}

      # Prevent HTTP/3 (QUIC) from bypassing mitmproxy; clients fall back to TCP.
      ${config.networking.firewall.package}/bin/iptables -w -t filter -I nixos-filter-forward 1 \
        -i ${apInterface} -p udp --dport 443 -j REJECT
    '';
  };

  networking.firewall.interfaces = {
    "${apInterface}" = {
      allowedTCPPorts = [
        53
        transparentProxyPort
      ];
      allowedUDPPorts = [
        53
        67
      ];
    };
  };

  systemd.targets."mimir-hotspot" = {
    description = "mimir WiFi hotspot routed through mitmproxy";
    wants = [
      "mitmproxy.service"
      "hostapd.service"
      "dnsmasq.service"
    ];
    after = [ "mitmproxy.service" ];
  };
}
