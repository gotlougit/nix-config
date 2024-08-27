{ pkgs, ... }:

let
  hostname = "kratos";
  user = "gotlou";
in {

  programs.direnv = {
    enable = true;
    nix-direnv = { enable = true; };
  };

  programs.skim = {
    enable = true;
    enableFishIntegration = true;
  };

  xdg.configFile."macchina/macchina.toml".text = ''
    show = ["Host", "Machine", "Kernel", "Distribution", "Shell", "Uptime", "Processor", "ProcessorLoad", "Memory", "Battery"]
  '';

  # Enable starship
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      format = "$directory$git_branch$git_commit\${custom.sandbox}$character";
      git_branch.format = "[\\($branch\\)](purple) ";
      git_commit.format = "[\\($hash\\)](purple) ";
      character = {
        success_symbol = "[λ](yellow)";
        error_symbol = "[λ](red)";
      };
      directory.style = "cyan";
      nix_shell.format = "[$symbol](blue)";
      custom.sandbox = {
        when = "grep 'systemd' /proc/1/cmdline";
        command = "echo -n '⚠️'";
        shell = "sh";
      };
    };
  };

  # Enable zoxide
  programs.zoxide = {
    enable = true;
    options = [ "--cmd cd" ];
    enableFishIntegration = true;
  };

  # Add shell with custom config
  programs.fish = {
    enable = true;
    shellAliases = {
      vi = "hx";
      open = "xdg-open";
      rollback-config = "sudo nixos-rebuild switch --rollback";
      switch-config =
        "sudo nixos-rebuild switch --flake /home/${user}/nixos#${hostname}";
      quick-switch-config = "switch-config --offline";
      update-config =
        "sudo nix flake update /home/${user}/nixos && sudo nixos-rebuild switch --flake /home/${user}/nixos#${hostname}";
      switch-config-boot =
        "sudo nixos-rebuild boot --flake /home/${user}/nixos#${hostname}";
      cat = "bat";
      diff = "difft";
      du = "dust";
      ls = "eza";
      # "." = "hx .";
      less = "bat --style plain";
      enter-rust-dev =
        "nix develop /home/${user}/nixos/project-flakes/generic-rust-dev/ --command code-sandbox";
      import-rust-dev =
        "cp /home/${user}/nixos/project-flakes/generic-rust-dev/* .; cp /home/${user}/nixos/project-flakes/generic-rust-dev/.envrc .";
      enter-golang-dev =
        "nix develop /home/${user}/nixos/project-flakes/generic-golang-dev/ --command code-sandbox";
      import-golang-dev =
        "cp /home/${user}/nixos/project-flakes/generic-golang-dev/* .; cp /home/${user}/nixos/project-flakes/generic-golang-dev/.envrc .";
      enter-cpp-dev =
        "nix develop /home/${user}/nixos/project-flakes/generic-c-cpp-dev/ --command code-sandbox";
      import-cpp-dev =
        "cp /home/${user}/nixos/project-flakes/generic-c-cpp-dev/* .; cp /home/${user}/nixos/project-flakes/generic-c-cpp-dev/.envrc .";
      scanfor =
        "set RES $(rg -n . | sk); hx +$(echo $RES | cut -d ':' -f 2) $(echo $RES | cut -d ':' -f 1)";
    };
    interactiveShellInit = ''
      macchina
      fish_vi_key_bindings
    '';
    shellInit = ''
      set -Ux XDG_CACHE_HOME "$HOME/.cache"
      set -Ux XDG_CONFIG_HOME "$HOME/.config"
      set -Ux XDG_DATA_HOME "$HOME/.local/share"
      set -Ux XDG_STATE_HOME "$HOME/.local/state"

      set -Ux PAGER "bat --style plain"
      set -Ux GDK_SCALE "1"

      # Force Electron apps to use Wayland
      set -Ux NIXOS_OZONE_WL "1"

      # Disable greeting
      set -U fish_greeting
    '';
  };

  home.packages = with pkgs; [
    # Rust replacements
    bat # cat
    difftastic # diff
    du-dust # du
    skim # fzf
    hexyl # hexdump
    eza # ls
    ripgrep # grep
    fd # Fast `find` replacement
    tealdeer # Rust implementation of tldr
    scc # loc replacement written in go
    bottom # htop replacement in rust
    # Required for above config to work
    macchina # Nice startup screen for terminal

    # Shell utils I like to use
    file # To show type of file
    aria # download manager
    bash # Keep around explicitly for legacy purposes
    socat # Socket cat
    sqlite # No intro needed
    age # A sane encrytion/decryption tool made for mortals
    bear # Generate autocomplete for large projects
    dig # for DNS testing
    ffmpeg # Multimedia Swiss Army Knife
    gh # Github CLI
    guerrilla # Generate temp emails for signups
    hut # Sourcehut CLI
    img2pdf # Useful utility
    jq # JSON manipulator
    magic-wormhole-rs # Direct file transfers
    magit # Advanced git UI using emacs
    pandoc # Convert docs
    # picard # Tag music files
    poppler_utils # PDF conversion and misc utils
    tetex # LaTEX related tooling
    p7zip # Useful for decompressing
    unzip # Useful for decompressing ZIP files
    wget # Another, simpler download manager
    whois # Useful utility
    wl-clipboard # CLI util for copying and pasting in Wayland
    yt-dlp # Useful video download utility
    zip # Create ZIP files from CLI
  ];
}
