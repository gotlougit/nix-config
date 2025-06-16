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

      collaboration_panel.button = false;
      notification_panel.button = false;
      project_panel.button = false;
      outline_panel.button = false;

      terminal.button = false;
      terminal.shell.program = "fish";
      features.inline_completion_provider = "none";
      use_system_path_prompts = false;
      slash_commands.docs.enabled = true;

      assistant.button = true;
      assistant.enable_experimental_live_diffs = true;
      assistant = {
        version = "2";
        default_model = {
          model = "claude-opus-4-20250514";
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
        normal_model = {
          max_output_tokens = 32000;
          cache_configuration = {
            min_total_token = 2048;
            should_speculate = true;
            max_cache_anchors = 4;
          };
          max_tokens = 200000;
          supports_thinking = false;
        };
      in [
        # NOTE: this is for Max plans only
        # (ultra_think // {
        #   name = "claude-opus-4-20250514";
        #   display_name = "Magnus";
        # })
        (ultra_think // {
          name = "claude-sonnet-4-20250514";
          display_name = "Claude Sonnet 4 (Thinking)";
        })
       (normal_model // {
          name = "claude-sonnet-4-20250514";
          display_name = "Claude Sonnet 4 (Normal)";
        })
       (normal_model // {
          name = "claude-3-7-sonnet-20250219";
          display_name = "Claude Sonnet 3.7 (Normal)";
        })
       (normal_model // {
          name = "claude-3-5-haiku-20241022";
          display_name = "Claude Haiku 3.5 (Normal)";
        })
      ];
    };
  };
}
