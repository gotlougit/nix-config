{ pkgs, ... }: {
  home.packages = [
    pkgs.zed-editor
  ];
  xdg.configFile."zed/settings.json".text = builtins.toJSON {
    telemetry.diagnostics = false;
    telemetry.metrics = false;
    autosave = "on_focus_change";
    cursor_blink = false;
    tab_bar.show = false;
    git.inline_blame.enabled = false;
    indent_guides.enabled = false;
    vim_mode = true;
    projects_online_by_default = false;
    toolbar.quick_actions = false;
    auto_update = false;
    gutter.code_actions = false;
    gutter.folds = false;
    gutter.runnables = false;
    gutter.line_numbers = false;
    assistant.button = false;
    collaboration_panel.button = false;
    chat_panel.button = false;
    notification_panel.button = false;
    terminal.button = false;
    terminal.shell.program = "fish";
    project_panel.button = false;
    outline_panel.button = false;
    features.inline_completion_provider = "none";
    lsp.rust-analyzer.binary.path = "rust-analyzer";
    lsp.rust-analyzer.initialization_options = {
      check.overrideCommand = [ "x" "remote" "ra-check" ];
      procMacro.enable = false;
      diagnostics.disabled = [ "unresolved-proc-macro" "macro-error" ];
      cargo.buildScripts.enable = false;
    };
    use_system_path_prompts = false;
    assistant = {
      version = "1";
      provider = {
        default_model = "claude-3-5-sonnet";
        name = "anthropic";
        low_speed_timeout_in_seconds = 60;
      };
    };
    language_servers = ["rust-analyzer"];
    slash_commands.docs.enabled = true;
  };
}
