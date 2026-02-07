{ config, lib, ... }:
let
  cfg = {
    main = {
      "capslock" = "overload(nav, esc)";
      "esc" = "capslock";
      # Insert ( when tapped and be shift when held
      "leftshift" = "overload(shift, S-9)";
      # Insert ) when tapped and be shift when held
      "rightshift" = "overload(shift, S-0)";
      # Insert { when tapped and be alt when held
      "leftalt" = "overload(alt, S-[)";
      # Insert } when tapped and be alt when held
      "rightalt" = "overload(alt, S-])";
      # Insert [ when tapped and be alt when held
      "leftcontrol" = "overload(control, [)";
      # Insert ] when tapped and be alt when held
      "rightcontrol" = "overload(control, ])";
      # Use these for home and end for quick navigation
      "[" = "home";
      "]" = "end";
    };
    # vi keybindings for navigation
    nav = {
      "j" = "down";
      "k" = "up";
      "l" = "right";
      "h" = "left";
      "w" = "C-right";
      "b" = "C-left";
      "enter" = "backspace";
      "d" = "delete";
      "shift" = "layer(selection)";
    };
    # vi-like key bindings for selection
    selection = {
      "l" = "S-right";
      "h" = "S-left";
      "w" = "C-S-right";
      "b" = "C-S-left";
      "x" = "C-a";
      # These aren't really selections, but there wasn't a better place to put
      # them
      "k" = "pageup";
      "j" = "pagedown";
    };
  };
in
{
  services.keyd = {
    enable = true;
    keyboards.default.ids = [ "*" ];
    keyboards.default.settings = cfg;
  };
  systemd.services.keyd.serviceConfig = {
    InaccessiblePaths = "/persist";
  };
}
