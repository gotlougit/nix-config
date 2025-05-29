{ pkgs, ... }: {
  home.packages = [
    pkgs.zed-editor

    pkgs.llvmPackages_18.clang-tools # C/C++
    pkgs.rust-analyzer # Rust
    pkgs.gopls # Golang
    pkgs.nodePackages.bash-language-server # Bash
    pkgs.dockerfile-language-server-nodejs # Dockerfile
    pkgs.vscode-langservers-extracted # HTML/CSS/JSON
    pkgs.texlab # LaTEX

    # Python
    pkgs.python312Packages.python-lsp-server
    pkgs.ruff

    # Markdown
    pkgs.markdown-oxide
    pkgs.marksman

    # TS/JS
    pkgs.nodePackages.typescript-language-server
    pkgs.nodePackages.prettier

    # Nix
    pkgs.nixfmt-classic
    pkgs.nixd
  ];

  # xdg.configFile."zed/settings.json".text = builtins.toJSON {
  #   telemetry.diagnostics = false;
  #   telemetry.metrics = false;
  #   autosave = "on_focus_change";
  #   cursor_blink = false;
  #   tab_bar.show = false;
  #   git.inline_blame.enabled = false;
  #   indent_guides.enabled = false;
  #   vim_mode = true;
  #   projects_online_by_default = false;
  #   toolbar.quick_actions = false;
  #   auto_update = false;
  #   gutter.code_actions = false;
  #   gutter.folds = false;
  #   gutter.runnables = false;
  #   gutter.line_numbers = false;
  #   assistant.button = false;
  #   collaboration_panel.button = false;
  #   chat_panel.button = false;
  #   notification_panel.button = false;
  #   terminal.button = false;
  #   terminal.shell.program = "fish";
  #   project_panel.button = false;
  #   outline_panel.button = false;
  #   features.inline_completion_provider = "none";
  #   use_system_path_prompts = false;
  #   slash_commands.docs.enabled = true;
  # };
}
