{ ... }:

let
  hostname = builtins.getEnv "HOSTNAME";
  user = "gotlou";
in
{
  # Enable starship
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
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
    enableBashIntegration = true;
  };

  # Add shell with custom config
  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = {
      vi = "hx";
      open = "xdg-open";
      rollback-config = "sudo nixos-rebuild switch --rollback";
      switch-config = "sudo nixos-rebuild switch --flake /home/${user}/nixos#${hostname}";
      quick-switch-config = "switch-config --option substitute false";
      update-config = "sudo nix flake update /home/${user}/nixos && sudo nixos-rebuild switch --flake /home/${user}/nixos#${hostname}";
      switch-config-boot = "sudo nixos-rebuild boot --flake /home/${user}/nixos#${hostname}";
      cat = "bat";
      diff = "difft";
      du = "dust";
      ls = "eza";
      "." = "hx .";
      less = "bat --style plain";
      enter-rust-dev = "nix develop /home/${user}/nixos/project-flakes/generic-rust-dev/ --command code-sandbox";
      import-rust-dev = "cp /home/${user}/nixos/project-flakes/generic-rust-dev/* .; cp /home/${user}/nixos/project-flakes/generic-rust-dev/.envrc .";
      enter-golang-dev = "nix develop /home/${user}/nixos/project-flakes/generic-golang-dev/ --command code-sandbox";
      import-golang-dev = "cp /home/${user}/nixos/project-flakes/generic-golang-dev/* .; cp /home/${user}/nixos/project-flakes/generic-golang-dev/.envrc .";
      enter-cpp-dev = "nix develop /home/${user}/nixos/project-flakes/generic-c-cpp-dev/ --command code-sandbox";
      import-cpp-dev = "cp /home/${user}/nixos/project-flakes/generic-c-cpp-dev/* .; cp /home/${user}/nixos/project-flakes/generic-c-cpp-dev/.envrc .";
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
      # GTK_THEME = "Nordic-darker";
      EDITOR = "hx";
      PAGER = "bat --style plain";
      GDK_SCALE = "1";
      # Stores timestamp for each command executed 
      HISTTIMEFORMAT = "%d/%m/%y %T ";
      # TODO: fix setting GTK_USE_PORTAL
      #GTK_USE_PORTAL = 1;
      NIXOS_OZONE_WL = "1";
    };
  };
}
