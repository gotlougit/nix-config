{ ... }: {
  services.dunst = {
    enable = true;
    settings = {
      global = {
        font = "Roboto Mono 8";
        width = 300;
        origin = "top-right";
        offset = "40x50";
        transparency = 0;
        frame_width = 2;
        separator_height = 2;
        sort = true;
      };
      urgency_low = {
        background = "#191919";
        foreground = "#BBBBBB";
      };
      urgency_normal = {
        background = "#191919";
        foreground = "#BBBBBB";
      };
      urgency_critical = {
        background = "#191919";
        foreground = "#DE6E7C";
      };
    };
  };
}
