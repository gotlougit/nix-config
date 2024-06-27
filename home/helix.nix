{ ... }:

{
  programs.helix.enable = true;
  programs.helix.defaultEditor = true;
  programs.helix.languages.language = [
    {
      name = "typescript";
      auto-format = true;
      formatter.command = "prettier --parser typescript";
    }
    {
      name = "nix";
      auto-format = true;
      formatter.command = "nixfmt";
    }
  ];
  programs.helix.settings = {
    # theme = "nord";

    editor.color-modes = true;
    editor.rulers = [ 80 ];
    editor.auto-save = true;
    editor.auto-format = true;

    editor.lsp.enable = true;
    editor.lsp.display-messages = true;
    editor.lsp.display-inlay-hints = false;

    editor.cursor-shape.insert = "bar";

    editor.statusline = {
      left = [ "mode" "spinner" "version-control" ];
      center = [ "file-name" "file-modification-indicator" ];
      right = [ "diagnostics" "selections" "position" "file-encoding" "file-line-ending" "file-type" ];
      separator = "│";
      mode.normal = "NORMAL";
      mode.insert = "INSERT";
      mode.select = "SELECT";
    };

    keys.normal.H = [ "goto_line_start" ];
    keys.normal.L = [ "goto_line_end" ];
    keys.normal.G = [ "goto_last_line" ];
    keys.normal.y = [ "yank" ":clipboard-yank" ];
  };

}
