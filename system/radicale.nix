{ lib, pkgs, ... }:

{
  services.radicale = {
    enable = true;
    package = pkgs.radicale-with-decsync;
    settings = {
      server = { hosts = [ "127.0.0.1:5232" ]; };
      auth = { type = "none"; };
      storage = {
        type = "radicale_storage_decsync";
        filesystem_folder = "/persist/sensitive/radicale/collections";
        decsync_dir = "/home/gotlou/Documents/DB/Calendar_contacts";
      };
    };
  };
  systemd.services.radicale = {
    enable = true;
    serviceConfig = {
      User = lib.mkForce "gotlou";
      WorkingDirectory = lib.mkForce "/persist/sensitive/radicale";
      StateDirectory = lib.mkForce "/persist/sensitive/radicale/collections";
    };
  };

}
