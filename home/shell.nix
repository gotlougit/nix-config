{ ... }:

let
  hostname = builtins.getEnv "HOSTNAME";
in
{
  # Enable starship
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
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

  # Add shell with custom config
  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = {
      vi = "hx";
      open = "xdg-open";
      switch-config = "sudo nixos-rebuild switch --flake /home/gotlou/nixos#${hostname}";
      update-config = "sudo nix flake update /home/gotlou/nixos && sudo nixos-rebuild switch --flake /home/gotlou/nixos#${hostname}";
      switch-config-boot = "sudo nixos-rebuild boot --flake /home/gotlou/nixos#${hostname}";
      cat = "bat";
      diff = "delta";
      du = "dust";
      ls = "eza";
      "." = "hx .";
      sudo = "doas";
      enter-rust-dev = "nix develop /home/gotlou/nixos/project-flakes/generic-rust-dev/";
      import-rust-dev = "cp /home/gotlou/nixos/project-flakes/generic-rust-dev/flake.nix .";
      enter-cpp-dev = "nix develop /home/gotlou/nixos/project-flakes/generic-c-cpp-dev/";
      import-cpp-dev = "cp /home/gotlou/nixos/project-flakes/generic-c-cpp-dev/flake.nix .";
      scanfor = "RES=$(rg -n . | sk); hx +$(echo $RES | cut -d ':' -f 2) $(echo $RES | cut -d ':' -f 1)";
    };
    initExtra = ''
      macchina
      source $(blesh-share)/ble.sh
      set -o vi
      eval "$(direnv hook bash)"
      eval "$(starship init bash)"
    '';
    sessionVariables = {
      SSH_AUTH_SOCK = "/run/user/1000/ssh-agent"; # Temp measure till sshield does this
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";

      # Not officially in the specification
      XDG_BIN_HOME = "$HOME/.local/bin";

      # TODO: maybe figure out if this is required or not
      # LD_LIBRARY_PATH = "/usr/local/lib:$LD_LIBRARY_PATH";
      GIT_ASKPASS = "/usr/bin/ksshaskpass";
      GTK_THEME = "Arc:dark";
      EDITOR = "hx";
      PAGER = "bat --style plain";
      GDK_SCALE = "1";
      # Stores timestamp for each command executed 
      HISTTIMEFORMAT = "%d/%m/%y %T ";
      # TODO: fix setting GTK_USE_PORTAL
      #GTK_USE_PORTAL = 1;
    };
  };
}
