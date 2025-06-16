{ pkgs, ... }:
let lspPackages = import ./lsp-list.nix { inherit pkgs; };
in {
  programs.zed-editor = {
    enable = true;
    package = pkgs.zed-editor-new;
    extraPackages = lspPackages;
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
      notification_panel.button = false;
      project_panel.button = false;
      outline_panel.button = false;

      terminal.button = false;
      terminal.shell.program = "fish";
      features.inline_completion_provider = "none";
      use_system_path_prompts = false;
      slash_commands.docs.enabled = true;
    };
  };
}
