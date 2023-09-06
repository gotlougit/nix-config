{ ... }: 

{
  programs.helix.enable = true;
  programs.helix.settings = {
    theme = "vantablack";

    editor.color-modes = true;
    editor.rulers = [ 80 ];
    editor.auto-save = true;

    editor.lsp.enable = true;
    editor.lsp.display-messages = true;
    editor.lsp.display-inlay-hints = false;
    
    editor.cursor-shape.insert = "bar";

    editor.statusline = {
      left = [ "mode" "spinner" ];
      center = [ "file-name" ];
      right = [ "diagnostics" "selections" "position" "file-encoding" "file-line-ending" "file-type" ];
      separator = "│";
      mode.normal = "NORMAL";
      mode.insert = "INSERT";
      mode.select = "SELECT";
    };

    keys.normal.H = [ "goto_line_start" ];
    keys.normal.L = [ "goto_line_end" ];
    keys.normal.G = [ "goto_last_line" ];
  };

  programs.helix.themes.vantablack = {
    "inherits" = "onedark";
    "ui" = { bg = "black"; };
    palette."black" = "#000000";
  };
  
}
