{ ... }:
{
  programs.waybar.enable = true;
  programs.waybar.style = ./waybar.css;
  programs.waybar.settings = {
    "bar-0" = {
      layer = "top";
      position = "left";
      # height= 32;
      modules-left = [
        "river/tags"
      ];
      modules-center = [
      ];
      modules-right = [
        "tray"
        "pulseaudio"
        "backlight"
        "battery"
        "clock"
      ];
      "river/tags" = { };
      "clock" = {
        interval = 30;
        # format = "{:%d %b %Y - %H:%M}";
        format = "{:%H\n%M}";
        tooltip = false;
      };
      "backlight" = {
        format = "💡\n {percent}%";
      };
      "pulseaudio" = {
        format = "{icon}\n {volume:2}%";
        format-bluetooth = "{icon}\n  {volume}%";
        format-muted = "🔇";
        format-icons = {
          "headphones" = "";
          "default" = [
            "🔊"
            "🔊"
          ];
        };
        "tooltip" = false;
      };
      "battery" = {
        states = {
          "good" = 95;
          "warning" = 30;
          "critical" = 15;
        };
        format = "{icon}\n {capacity}%";
        format-icons = [ "" "" "" "" "" ];
        tooltip = false;
      };
      "tray" = {
        icon-size = 22;
      };
    };
  };
}
