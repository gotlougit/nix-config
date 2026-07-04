{
  programs.ghostty = {
    enable = true;
    clearDefaultKeybinds = true;
    systemd.enable = true;
    enableFishIntegration = true;
    settings = {
      # Enable scroll bar
      scrollbar = "system";

      font-size = "12";

      # Middle click pastes from the primary selection
      # mouse-bind = "middle=primary_paste";

      keybind = [
        # Paste from the clipboard
        "ctrl+shift+v=paste_from_clipboard"

        # Split vertical (physical key: 9 with shift = "(" on US layout)
        "ctrl+shift+9=new_split:right"

        # Split horizontal (physical key: 0 with shift = ")" on US layout)
        "ctrl+shift+0=new_split:down"

        # Cycle through panes
        "ctrl+tab=goto_split:next"

        # Cycle through panes in reverse
        "ctrl+shift+tab=goto_split:previous"

        # Close a pane forcefully
        "ctrl+shift+q=close_surface"
      ];
    };
  };
}
