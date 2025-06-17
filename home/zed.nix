{ pkgs, ... }:
let lspPackages = import ./lsp-list.nix { inherit pkgs; };
in {
  programs.zed-editor = {
    enable = true;
    package = pkgs.zed-editor-new;
    extraPackages = lspPackages;
    userKeymaps = [
      # Main helix normal mode bindings
      {
        context = "vim_mode == helix_normal && !menu";
        bindings = {
          # Selection-first word movement (helix style)
          "w" = "vim::NextWordStart";
          "shift-w" = [ "vim::NextWordStart" { ignore_punctuation = true; } ];
          "b" = "vim::PreviousWordStart";
          "shift-b" =
            [ "vim::PreviousWordStart" { ignore_punctuation = true; } ];
          "e" = "vim::NextWordEnd";
          "shift-e" = [ "vim::NextWordEnd" { ignore_punctuation = true; } ];
          "shift-h" = "vim::StartOfLine";
          "shift-l" = "vim::EndOfLine";
          # Line selection
          "x" = "editor::SelectLine";
          # Helix-style matching bracket
          "m" = "vim::Matching";
          # Space leader key mappings
          "space f" = "file_finder::Toggle";
          "space b" = "pane::ActivateNextItem";
          "space w" = "workspace::Save";
          "space q" = "pane::CloseActiveItem";
          "space space" = "file_finder::Toggle";
          "/" = "pane::DeploySearch";
          # Delete and change (helix-style)
          "d" = [ "workspace::SendKeystrokes" "y d" ];
          "c" = [ "workspace::SendKeystrokes" "d i" ];
          # Motion repeats
          ";" = "vim::RepeatFind";
          "," = "vim::RepeatFindReversed";
          # LSP selection
          "alt-o" = "editor::SelectLargerSyntaxNode";
          # Stay in Helix Normal mode
          "escape" = "vim::SwitchToHelixNormalMode";
          "g g" = "vim::StartOfDocument";
          "g e" = "vim::EndOfDocument";
          "g h" = "vim::StartOfLine";
          "g l" = "vim::EndOfLine";
          "g s" = "vim::FirstNonWhitespace";
          "g d" = "editor::GoToDefinition";
          "g shift-d" = "editor::GoToDeclaration";
          "g y" = "editor::GoToTypeDefinition";
          "g r" = "editor::FindAllReferences";
          "g i" = "editor::GoToImplementation";
          "g t" = "vim::WindowTop";
          "g c" = "vim::WindowMiddle";
          "g b" = "vim::WindowBottom";
          "g a" = "pane::AlternateFile";
          "g n" = "pane::ActivateNextItem";
          "g p" = "pane::ActivatePreviousItem";
          "g k" = "editor::SelectUp";
          "g j" = "editor::SelectDown";
          "g ." = "vim::ChangeListNewer";
        };
      }
      # Visual mode specific bindings
      {
        context =
          "Editor && VimControl && vim_mode == visual && !VimWaiting && !menu";
        bindings = {
          "b" = [ "workspace::SendKeystrokes" "v v ctrl-shift-alt-b" ];
          "w" = [ "workspace::SendKeystrokes" "v v ctrl-shift-alt-w" ];
          "e" = [ "workspace::SendKeystrokes" "v v ctrl-shift-alt-e" ];
          "x" = [ "workspace::SendKeystrokes" "j g l" ];
          "g g" = "vim::StartOfDocument";
          "g e" = "vim::EndOfDocument";
          "g h" = "vim::StartOfLine";
          "g l" = "vim::EndOfLine";
          "g s" = "vim::FirstNonWhitespace";
          "g k" = "editor::SelectUp";
          "g j" = "editor::SelectDown";
        };
      }
      # Escape to helix normal mode
      {
        context = "Editor && vim_mode != helix_normal && !VimWaiting";
        bindings = { "escape" = "vim::SwitchToHelixNormalMode"; };
      }
      {
        context =
          "Editor && vim_mode == visual || vim_mode == helix_normal && !VimWaiting && !VimObject";
        bindings = { "x" = "editor::SelectLine"; };
      }
      {
        context = "Editor && !VimControl";
        bindings = { "escape" = "vim::SwitchToHelixNormalMode"; };
      }
    ];
    userSettings = {
      telemetry.diagnostics = false;
      telemetry.metrics = false;

      autosave = "on_focus_change";
      cursor_blink = false;
      tab_bar.show = true;
      git.inline_blame.enabled = false;
      indent_guides.enabled = true;

      vim_mode = true;
      vim.default_mode = "helix_normal";

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
