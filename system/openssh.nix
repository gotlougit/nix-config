{ pkgs, ... }:
{
  services.openssh = {
    enable = true;
    # Use the Fil-C memory-safe build of OpenSSH for the sshd daemon. The
    # Fil-C binary is directly executable: its ELF interpreter is the Fil-C
    # runtime loader (ld-yolo-x86_64.so) from the filc-sysroot, which lives in
    # the package's runtime closure, and it links against the Fil-C runtime
    # libs (libpizlo/yoloc/yolom/libc++). See overlays/openssh-filc.
    #
    # NOTE: this is an experimental memory-safe build. Keep local/console
    # access available when first switching, in case the Fil-C sshd has a
    # runtime issue. The NixOS openssh module also runs `sshd -G -T` on the
    # generated sshd_config as a build-time check (system.checks), so a broken
    # Fil-C sshd would fail the rebuild (not lock you out of the running box).
    package = pkgs.openssh-filc;
    startWhenNeeded = true;
    settings = {
      PasswordAuthentication = true;
      KbdInteractiveAuthentication = false;
      PubkeyAuthentication = true;
      PermitRootLogin = "no";
      MaxAuthTries = 10;
    };
  };
  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 22 ];
  systemd.services."sshd@".serviceConfig = {
    # Protect Impermanence paths, which are full of private data
    InaccessiblePaths = [ "/persist" ];
  };
}
