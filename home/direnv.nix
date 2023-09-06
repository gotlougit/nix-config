{ ... }:

{
  xdg.configFile."direnv/direnvrc".text = ''
    source /run/current-system/sw/share/nix-direnv/direnvrc
  '';
}
