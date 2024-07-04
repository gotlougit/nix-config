{ pkgs, ... }: {
  programs.eww = {
    enable = true;
    configDir = ./.;
    package = pkgs.eww-wayland;
  };
}
