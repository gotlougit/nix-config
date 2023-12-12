{ ... }:

{

  programs.wezterm = {
    enable = true;
    enableBashIntegration = true;
  };

  home.file.".wezterm.lua".text = ''
    -- Pull in the wezterm API
    local wezterm = require 'wezterm'

    -- This table will hold the configuration.
    local config = {}

    -- In newer versions of wezterm, use the config_builder which will
    -- help provide clearer error messages
    if wezterm.config_builder then
      config = wezterm.config_builder()
    end

    config.enable_wayland = false;
    
    -- Use alternate SSH backend to get around reported timeout issues
    config.ssh_backend = "Ssh2"

    -- Use WebGPU
    -- config.front_end = "WebGpu";

    -- Enable scroll bar
    config.enable_scroll_bar = true;

    -- Disable tab bar
    config.enable_tab_bar = false;

    -- Disable all default keyboard shortcuts to avoid conflict
    config.disable_default_key_bindings = true;

    config.keys = {
      -- paste from the clipboard
      { key = 'V', mods = 'CTRL|SHIFT', action = wezterm.action.PasteFrom 'Clipboard' },

      -- paste from the primary selection
      { key = 'V', mods = 'CTRL|SHIFT', action = wezterm.action.PasteFrom 'PrimarySelection' },
      {
        -- Split vertical
        key = '(',
        mods = 'CTRL|SHIFT',
        action = wezterm.action.SplitPane {
          direction = 'Right',
          size = { Percent = 50 },
        },
      },
      {
        -- Split horizontal
        key = ')',
        mods = 'CTRL|SHIFT',
        action = wezterm.action.SplitPane {
          direction = 'Down',
          size = { Percent = 50 },
        },
      },
      {
        -- Cycle through panes
        key = 'Tab',
        mods = 'CTRL',
        action = wezterm.action.ActivatePaneDirection 'Next',
      },
      {
        -- Cycle through panes in reverse
        key = 'Tab',
        mods = 'CTRL|SHIFT',
        action = wezterm.action.ActivatePaneDirection 'Prev',
      },
      {
        -- Close a pane forcefully
        key = 'Q',
        mods = 'CTRL|SHIFT',
        action = wezterm.action.CloseCurrentPane { confirm = false; },
      }
    }
    config.color_scheme = 'nord';
    -- and finally, return the configuration to wezterm
    return config
  '';
}
