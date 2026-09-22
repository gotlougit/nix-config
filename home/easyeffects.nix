{ ... }:

{
  services.easyeffects.enable = false;
  services.easyeffects.preset = "thinkpad-unsuck";
  xdg.dataFile."easyeffects/output/thinkpad-unsuck.json" = {
    source = ./thinkpad-unsuck.json;
    force = true;
  };
}
