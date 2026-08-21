{ inputs, pkgs, ... }:

{
  imports = [
    inputs.omega.nixosModules.omega
    inputs.lightpanda.nixosModules.default
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

      After I ask you to make a change, just send me the patch of your changes unless
      I tell you otherwise. Do not send .gitignore with those changes, as I do not really need it.
    '';
    # Optional: extra groups for the clanker user (e.g. docker, kvm)
    # extraGroups = [ "docker" ];
    logLevel = "debug";
    gitHost = {
      enable = true;
      port = 5999;
      # TODO: gate over tailscale and localhost only
      listenAddress = "0.0.0.0";
    };
    gitUserName = "clanker";
    gitUserEmail = "omega@gotlou.com";
  };
}
