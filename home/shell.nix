{ ... }:

let
  hostname = builtins.getEnv "HOSTNAME";
in
{
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
      diff = "difft";
      fzf = "sk";
      ls = "eza";
      grep = "rg";
      cloc = "loc";
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
      PAGER = "bat";
      GDK_SCALE = "1";

      # TODO: fix setting GTK_USE_PORTAL
      #GTK_USE_PORTAL = 1;
    };
  };
}
