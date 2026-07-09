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

      # Make new windows start at ~ by default
      working-directory = "home";
      window-inherit-working-directory = false;

      keybind = [
        # Paste from the clipboard
        "ctrl+shift+v=paste_from_clipboard"

        # Split vertical
        "ctrl+shift+9=new_split:right"

        # Split horizontal
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
