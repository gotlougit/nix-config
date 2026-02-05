# Shared shell configuration used by both host and microvm
{ pkgs, ... }:

{

  imports = [
    ./helix.nix
  ];

  # Programs that work in both host and microvm
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.skim = {
    enable = true;
    enableFishIntegration = true;
  };

  # Enable starship
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      format = "$directory$git_branch$git_commit\$character";
      git_branch.format = "[\\($branch\\)](purple) ";
      git_commit.format = "[\\($hash\\)](purple) ";
      character = {
        success_symbol = "[λ](yellow)";
        error_symbol = "[λ](red)";
      };
      directory.style = "cyan";
      nix_shell.format = "[$symbol](blue)";
    };
  };

  # Enable zoxide
  programs.zoxide = {
    enable = true;
    options = [ "--cmd cd" ];
    enableFishIntegration = true;
  };

  # Fish shell - common aliases and settings
  programs.fish = {
    enable = true;
    shellAliases = {
      vi = "hx";
      cat = "bat";
      diff = "difft";
      du = "dust";
      ls = "eza";
      htop = "btm --battery --tree --basic --process_memory_as_value";
      less = "bat --style plain";
      scanfor = "set RES $(rg -n . | sk); hx +$(echo $RES | cut -d ':' -f 2) $(echo $RES | cut -d ':' -f 1)";
    };

    shellInit = ''
      set -Ux XDG_CACHE_HOME "$HOME/.cache"
      set -Ux XDG_CONFIG_HOME "$HOME/.config"
      set -Ux XDG_DATA_HOME "$HOME/.local/share"
      set -Ux XDG_STATE_HOME "$HOME/.local/state"
      set -Ux PAGER "bat --style plain"

      # Disable greeting
      set -U fish_greeting

      set -Ux GDK_SCALE "1"
      # Force Electron apps to use Wayland
      set -Ux NIXOS_OZONE_WL "1"
    '';

    interactiveShellInit = ''
      fish_vi_key_bindings
    '';
  };

  # Common packages for both environments
  home.packages = with pkgs; [
    # Rust replacements
    bat
    difftastic
    dust
    skim
    hexyl
    eza
    ripgrep
    fd
    tealdeer
    scc
    bottom

    # Shell utils
    ast-grep
    file
    aria2
    bash
    socat
    sqlite
    age
    dig
    ffmpeg
    jq
    magic-wormhole-rs
    pandoc
    wget
    zip
    unzip

    # Dev tools
    gh
    hut
    git
  ];
}
