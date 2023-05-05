{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "gotlou";
  home.homeDirectory = "/home/gotlou";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "22.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  systemd.user.services.mpris-proxy = {
    Unit.Description = "Mpris proxy";
    Unit.After = [ "network.target" "sound.target" ];
    Service.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
    Install.WantedBy = [ "default.target" ];
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".config/gh" = {
      source = /home/gotlou/dotfiles/gh;
      recursive = true;
    };
    ".config/hut" = {
      source = /home/gotlou/dotfiles/hut;
      recursive = true;
    };
    ".config/nvim" = {
      source = /home/gotlou/dotfiles/nvim;
      recursive = true;
    };
    ".config/legendary" = {
      source = /home/gotlou/dotfiles/legendary;
      recursive = true;
    };
    ".ssh" = {
        source = /home/gotlou/dotfiles/.ssh;
        recursive = true;
    };
    ".gnupg" = {
        source = /home/gotlou/dotfiles/.gnupg;
        recursive = true;
    };
    ".local/share/kwalletd" = {
        source = /home/gotlou/dotfiles/kwalletd;
        recursive = true;
    };
    ".local/share/dolphin" = {
        source = /home/gotlou/dotfiles/dolphin;
        recursive = true;
    };
    ".local/share/klipper" = {
        source = /home/gotlou/dotfiles/klipper;
        recursive = true;
    };
    ".local/share/kscreen" = {
        source = /home/gotlou/dotfiles/kscreen;
        recursive = true;
    };
    ".local/share/RecentDocuments" = {
        source = /home/gotlou/dotfiles/RecentDocuments;
        recursive = true;
    };
    ".local/share/konsole" = {
        source = /home/gotlou/dotfiles/konsole;
        recursive = true;
    };
    "~/.config/rhythmbox" = {
        source = /home/gotlou/dotfiles/rhythmbox;
        recursive = true;
    };
    "~/.config/gtk-3.0" = {
        source = /home/gotlou/dotfiles/gtk-3.0;
        recursive = true;
    };
    "~/.config/gtk-4.0" = {
        source = /home/gotlou/dotfiles/gtk-4.0;
        recursive = true;
    };
    "~/.config/KDE" = {
        source = /home/gotlou/dotfiles/KDE;
        recursive = true;
    };
    "~/.config/kde.org" = {
        source = /home/gotlou/dotfiles/kde.org;
        recursive = true;
    };
    "~/.config/plasma-workspace" = {
        source = /home/gotlou/dotfiles/plasma-workspace;
        recursive = true;
    };
    "~/.config/xsettingsd" = {
        source = /home/gotlou/dotfiles/xsettingsd;
        recursive = true;
    };
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  /home/gotlou/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/gotlou/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
