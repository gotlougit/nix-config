{ pkgs, ... }:

{
  xdg.configFile."sclirc".text = ''
    wrap-at = 80
    save-history = true
    partition-contacts = true
    show-names = true
  '';
  home.packages = with pkgs; [ scli ];
}
