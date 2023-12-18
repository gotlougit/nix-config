{ config, ... }:
{
  imports = [
    ./display-scale.nix
    ./panel.nix
    ./plasma.nix
  ];

  # Import the dynamic workspaces plugin used for kwin
  # TODO: make this more declarative and less dependent on my specific path
  home.file.".local/share/kwin/scripts/dynamic_workspaces" = {
    source = config.lib.file.mkOutOfStoreSymlink /home/gotlou/nixos/dotfiles/dynamic_workspaces;
    recursive = true;
  };

  # Stores dolphin preferences
  home.file.".local/share/dolphin/dolphinstaterc".text = ''
    [State]
    1920x1080 screen: Window-Maximized=true
    State=AAAA/wAAAAD9AAAAAwAAAAAAAAEEAAAD8vwCAAAAAvsAAAAWAGYAbwBsAGQAZQByAHMARABvAGMAawAAAAAuAAAB5wAAAAoBAAAD+wAAABQAcABsAGEAYwBlAHMARABvAGMAawEAAAAuAAAD8gAAAF0BAAADAAAAAQAAALgAAAPy/AIAAAAB+wAAABAAaQBuAGYAbwBEAG8AYwBrAAAAAC4AAAPyAAAACgEAAAMAAAADAAAHgAAAAL78AQAAAAH7AAAAGAB0AGUAcgBtAGkAbgBhAGwARABvAGMAawAAAAAAAAAHgAAAAAoBAAADAAAGXQAAA/IAAAAEAAAABAAAAAgAAAAI/AAAAAEAAAACAAAAAQAAABYAbQBhAGkAbgBUAG8AbwBsAEIAYQByAQAAAAD/////AAAAAAAAAAA=
  '';
 
}
