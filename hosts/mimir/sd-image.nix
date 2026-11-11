{ config, lib, ... }:
{
  sdImage = {
    compressImage = true;
    # The default expander targets /, which is a tmpfs here.  The NIXOS_SD
    # partition is grown by hosts/mimir/expand.nix instead.
    expandOnBoot = lib.mkForce false;
    nixPathRegistrationFile = "/mnt/nix-path-registration";

    populateRootCommands = lib.mkForce ''
      mkdir -p ./files/boot/firmware ./files/persist
      ${config.boot.loader.raspberry-pi.bootPopulateCmd} -c ${config.system.build.toplevel} -b ./files/boot
    '';
  };

  systemd.services.register-nix-paths.preStart = ''
    mkdir -p /nix/var/nix/profiles /nix/var/nix/gcroots /nix/var/nix/db
  '';

}
