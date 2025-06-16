{ pkgs, lib, ... }: {
  programs.zed-editor = {
    enable = true;
    package = pkgs.zed-editor-new;
    extraPackages = with pkgs; [
      llvmPackages_18.clang-tools # C/C++
      rust-analyzer # Rust
      gopls # Golang
      nodePackages.bash-language-server # Bash
      dockerfile-language-server-nodejs # Dockerfile
      vscode-langservers-extracted # HTML/CSS/JSON
      texlab # LaTEX

      # Python
      python312Packages.python-lsp-server
      ruff

      # Markdown
      markdown-oxide
      marksman

      # TS/JS
      nodePackages.typescript-language-server
      nodePackages.prettier

      # Nix
      nixfmt-classic
      nixd
    ];
    userSettings = {
      telemetry.diagnostics = false;
      telemetry.metrics = false;

      autosave = "on_focus_change";
      cursor_blink = false;
      tab_bar.show = true;
      git.inline_blame.enabled = false;
      indent_guides.enabled = true;

      vim_mode = false;

      projects_online_by_default = false;
      toolbar.quick_actions = false;
      auto_update = false;
      gutter.code_actions = true;
      gutter.folds = true;
      gutter.runnables = false;
      gutter.line_numbers = true;

      assistant.button = false;
      collaboration_panel.button = false;
      chat_panel.button = false;
      notification_panel.button = false;
      project_panel.button = false;
      outline_panel.button = false;

      terminal.button = false;
      terminal.shell.program = "fish";
      features.inline_completion_provider = "none";
      use_system_path_prompts = false;
      assistant = {
        version = "1";
        provider = {
          default_model = "claude-3-5-sonnet";
          name = "anthropic";
          low_speed_timeout_in_seconds = 60;
        };
      };
      slash_commands.docs.enabled = true;
      theme = lib.mkForce {
        mode = "system";
        dark = "Nord";
      };
      ui_font_size = lib.mkForce 16;
      buffer_font_size = lib.mkForce 16;
    };
  };
}
