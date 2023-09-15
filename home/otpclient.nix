{ lib, ... }:
{
  xdg.configFile."otpclient.cfg".text = lib.generators.toINI { } {
    config = {
      db_path = "/home/gotlou/Documents/DB/twofacauth";
      auto_lock = false;
      inactivity_timeout = 120;
    };
  };
}
