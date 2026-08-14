{ inputs, pkgs, ... }:

{
  imports = [
    inputs.omega.nixosModules.omega
  ];

  services.omega = {
    enable = true;
    humanUsers = [ "gotlou" ];
    # Optional: path to an env file with OPENAI_API_KEY etc.
    envFile = "/persist/omega-env";
    # add whatever the agent needs
    packages = with pkgs; [
      git
      nix
      ripgrep
      fd
      bun
      python3
      lightpanda
      curl
    ];
    extraSystemPrompt = ''
      When searching for text or files, use `rg` or `fd` from the shell
      rather than normal `grep` or `find` as rg and fd are much faster.

      A headless browser called `lightpanda` is at your disposal. You can
      use `lightpanda fetch <url> --dump markdown` to get a Markdown rendered
      version of a particular webpage. Using this and html.duckduckgo.com as a
      starting point, you can browse the web easily to find up to date information.
      Prefer this over curl when you wish to do web searches or interact with websites.
      For calling APIs (eg. to read files from a remote GitHub repo without cloning)
      it is still preferred to use `curl`.
    '';
    # Optional: extra groups for the clanker user (e.g. docker, kvm)
    # extraGroups = [ "docker" ];
    logLevel = "debug";
    homeManager = {
      enable = true;
      config = {
        programs.git = {
          enable = true;
          userName = "clanker";
          userEmail = "omega@gotlou.com";
        };

        # Clean up old home-manager generations
        systemd.user.services.home-manager-gc = {
          Unit = {
            Description = "Clean up old home-manager generations";
          };

          Service = {
            Type = "oneshot";
            ExecStart = "${pkgs.bash}/bin/bash ${../home/clean-old-generations.sh}";
          };
        };

        systemd.user.timers.home-manager-gc = {
          Unit = {
            Description = "Timer for cleaning up old home-manager generations";
          };

          Timer = {
            OnCalendar = "weekly";
            Persistent = true;
          };

          Install = {
            WantedBy = [ "timers.target" ];
          };
        };
      };
    };
  };
}
