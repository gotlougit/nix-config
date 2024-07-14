{ pkgs, lib, ... }:

{
  programs.helix.enable = true;
  programs.helix.defaultEditor = true;
  programs.helix.languages.language-server.gpt = {
    command = "${lib.getExe pkgs.helix-gpt}";
    args = [ "--handler" "codeium" ];
  };
  programs.helix.languages.language = [
    {
      name = "typescript";
      language-servers = [ "typescript-language-server" "gpt" ];
      formatter.command = "prettier";
      formatter.args = [ "--parser" "typescript" ];
      formatter.binary = "${lib.getExe pkgs.nodePackages.prettier}";
    }
    {
      name = "nix";
      language-servers = [ "nil" "gpt" ];
      formatter.binary = "${lib.getExe pkgs.nixfmt-classic}";
      formatter.command = "nixfmt";
    }
    {
      name = "cpp";
      language-servers = [ "clangd" "gpt" ];
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
      right = [
        "diagnostics"
        "selections"
        "position"
        "file-encoding"
        "file-line-ending"
        "file-type"
      ];
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

  # LSPs and formatters installed globally for convenience
  programs.helix.extraPackages = with pkgs; [
    llvmPackages_18.clang-tools # C/C++
    rust-analyzer # Rust
    gopls # Golang
    nodePackages.bash-language-server # Bash
    dockerfile-language-server-nodejs # Dockerfile
    vscode-langservers-extracted # HTML/CSS/JSON
    texlab # LaTEX

    # Markdown
    markdown-oxide
    marksman

    # TS/JS
    nodePackages.typescript-language-server
    nodePackages.prettier

    # Nix
    nixfmt-classic
    nil

    # GPT in helix
    helix-gpt
  ];

}
