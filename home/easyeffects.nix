{ ... }:

{
  services.easyeffects.enable = true;
  services.easyeffects.preset = "thinkpad-unsuck";
  xdg.configFile."easyeffects/output/thinkpad-unsuck.json".source =
    ./thinkpad-unsuck.json;
}
