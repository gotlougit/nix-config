{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.mullvad-tailscale;
  pkg = pkgs.mullvad-tailscale;

in
{
  options.services.mullvad-tailscale = {
    enable = mkEnableOption "mullvad-tailscale nftables configuration for running Mullvad VPN alongside Tailscale/Zerotier";

    package = mkOption {
      type = types.package;
      default = pkg;
      defaultText = literalExpression "pkgs.mullvad-tailscale";
      description = "The mullvad-tailscale package to use.";
    };

    rulesFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        Path to a custom nftables rules file. If not set, the default rules from
        the mullvad-tailscale package will be used. The default rules exclude
        Tailscale IPs from the Mullvad VPN tunnel.
      '';
    };

    enableAutoConf = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to automatically apply the nftables rules at boot via a oneshot
        systemd service. This only applies the nftables configuration (equivalent
        to `mnf conf`) without connecting to Mullvad VPN. You still need to run
        `mnf up` manually to connect.
      '';
    };

    tailscaleInterface = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "tailscale0";
      description = ''
        Tailscale interface to add to the nftables excluded IPs. If set, the
        nftables rules will be updated to exclude this interface's IPs from
        the Mullvad tunnel.
      '';
    };

    tailscaleTCPPorts = mkOption {
      type = types.listOf types.port;
      default = [ ];
      example = [ 9100 22 ];
      description = ''
        TCP ports to open on the tailscale interface in the firewall. Useful
        for services (e.g. Prometheus node_exporter, SSH) that should be
        reachable over Tailscale while Mullvad VPN is active. Only takes
        effect when `tailscaleInterface` is also set.
      '';
    };

    tailscaleUDPPorts = mkOption {
      type = types.listOf types.port;
      default = [ ];
      example = [ 51820 ];
      description = ''
        UDP ports to open on the tailscale interface in the firewall. Useful
        for services that should be reachable over Tailscale while Mullvad
        VPN is active. Only takes effect when `tailscaleInterface` is also
        set.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    # Ensure nftables is available
    networking.nftables.enable = true;

    systemd.services.mullvad-tailscale-conf = mkIf cfg.enableAutoConf {
      description = "Mullvad-Tailscale nftables Configuration";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" "tailscaled.service" ];
      wants = [ "network-online.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${cfg.package}/bin/mnf conf ${optionalString (cfg.rulesFile != null) "-f ${cfg.rulesFile}"}";
      };
    };

    # Open firewall ports on tailscale interface if configured
    networking.firewall.interfaces = mkIf (cfg.tailscaleInterface != null && (cfg.tailscaleTCPPorts != [ ] || cfg.tailscaleUDPPorts != [ ])) {
      "${cfg.tailscaleInterface}" = {
        allowedTCPPorts = cfg.tailscaleTCPPorts;
        allowedUDPPorts = cfg.tailscaleUDPPorts;
      };
    };
  };
}
