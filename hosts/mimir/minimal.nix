{ lib, pkgs, ... }:
{
  nix.enable = false;

  # Nix itself is disabled, but a usable store layout is kept so the host
  # can receive paths over SSH for deployment.
  systemd.tmpfiles.rules = [
    "d /nix/var 0755 root root -"
    "d /nix/var/nix 0755 root root -"
    "d /nix/var/nix/profiles 0755 root root -"
    "d /nix/var/nix/gcroots 0755 root root -"
    "d /nix/var/nix/db 0755 root root -"
    "L+ /nix/var/nix/gcroots/booted-system - - - - /run/booted-system"
  ];

  boot.kernelParams = [
    "sysctl.vm.mem_profiling=never"
    "kfence.sample_interval=0"
    "damon_stat.enabled=N"
    "audit=0"
    "initcall_blacklist=ksm_init,tpm_init,init_tis"
    "psi=0"
    "ras=cec_disable"
    "nowatchdog"
    "nmi_watchdog=0"
    "cryptomgr.notests"
    "8250.nr_uarts=1"
    "transparent_hugepage=never"
    "cma=16M"
  ];

  boot.kernel.sysctl = {
    "kernel.panic_on_oops" = 1;
    "kernel.panic" = 10;
    "vm.swappiness" = 180;
    "vm.page-cluster" = 0;
    "vm.watermark_scale_factor" = 125;
    "vm.watermark_boost_factor" = 0;
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 100;
    memoryMax = 512 * 1024 * 1024;
    priority = 100;
  };

  services.lvm.enable = false;
  boot.bcache.enable = false;

  environment.defaultPackages = lib.mkForce [ ];
  xdg.mime.enable = false;
  xdg.icons.enable = false;
  xdg.sounds.enable = false;
  fonts.fontconfig.enable = false;

  documentation.enable = false;
  documentation.man.enable = false;
  documentation.nixos.enable = false;

  systemd.suppressedSystemUnits = [
    "systemd-importd.service"
    "sys-kernel-config.mount"
  ];

  security.pam.services.su.forwardXAuth = lib.mkForce false;

  services.journald.extraConfig = "SystemMaxUse=50M";

  # nix.gc.automatic requires nix.enable, which is disabled here. Run a
  # small local store GC directly instead of enabling the Nix daemon.
  systemd.services.mimir-nix-gc = {
    description = "Nix garbage collector";
    environment.NIX_REMOTE = "local";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.nix}/bin/nix-collect-garbage --delete-older-than 1d";
      Nice = 19;
    };
  };
  systemd.timers.mimir-nix-gc = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "weekly";
      RandomizedDelaySec = "30m";
      Persistent = true;
    };
  };

  # No RTC on the Pi.  Use chrony as a daemon instead of a one-shot boot
  # command: it starts early, keeps retrying when WiFi is not associated yet,
  # and steps the clock as soon as it gets a valid NTP reply.
  services.chrony = {
    enable = true;

    # Use IPs, not hostnames: DNS may still be down when chrony starts.
    servers = [
      "162.159.200.123"
      "216.239.35.0"
      "216.239.35.4"
    ];

    # There is no RTC to trim.
    enableRTCTrimming = false;

    # The default is already iburst; be explicit about the late-WiFi case.
    serverOption = "iburst";
  };
}
