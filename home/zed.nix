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

      helix_mode = true;

      projects_online_by_default = false;
      toolbar.quick_actions = false;
      auto_update = false;
      gutter.code_actions = true;
      gutter.folds = true;
      gutter.runnables = false;
      gutter.line_numbers = true;

      collaboration_panel.button = false;
      notification_panel.button = false;
      outline_panel.button = false;
      git_panel.button = false;
      title_bar.show_sign_in = false;
      title_bar.show_onboarding_banner = false;

      terminal.shell.program = "fish";
      features.inline_completion_provider = "none";
      use_system_path_prompts = false;
      slash_commands.docs.enabled = true;

      assistant.button = true;
      assistant.enable_experimental_live_diffs = true;
      assistant = {
        version = "2";
        default_model = {
          model = "claude-sonnet-4-latest-thinking";
          provider = "anthropic";
        };
        show_hints = false;
      };

      language_models.anthropic.version = "1";
      language_models.anthropic.api_url = "http://127.0.0.1:25784";
      language_models.anthropic.available_models = let
        ultra_think = {
          max_output_tokens = 32000;
          cache_configuration = {
            min_total_token = 2048;
            should_speculate = true;
            max_cache_anchors = 4;
          };
          supports_tools = true;
          supports_thinking = true;
          max_tokens = 200000;
          mode = {
            type = "thinking";
            budget_tokens = 32000;
          };
        };
      in [
        (ultra_think // {
          name = "claude-sonnet-4-latest-thinking";
          display_name = "Claude Sonnet 4 (Ultrathink)";
        })
      ];
    };
  };
}
