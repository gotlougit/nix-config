{ config, ... }:

{
  programs.tiny.enable = true;
  home.file.".config/tiny/config.yml" = {
    source = config.lib.file.mkOutOfStoreSymlink /persist/communication/tiny-config.yml;
  };

}
