{ ... }:

{
  programs.git = {
    enable = true;
    # Set name and email to use when creating commits
    userName = "Saksham Mittal";
    userEmail = "git@gotlou.com";
    extraConfig = {
      # Signing config
      gpg.format = "ssh";
      user.signingKey =
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINdqk3Yo5e67SNiTiZlIMlDHI5cD9L3hFatrFo+yM7zB signing-key";
      gpg.ssh.allowedSignersFile =
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINdqk3Yo5e67SNiTiZlIMlDHI5cD9L3hFatrFo+yM7zB signing-key";
      commit.gpgsign = true;
      # Make default branch be named "main"
      init.defaultBranch = "main";
      diff.renames = "copy";
      # Some file ending stuff
      core.autocrlf = "input";
      core.autoclrf = false;
      core.filemode = false;
      # Push current branch if nothing is specified
      push.default = "current";
    };
    # Ignore certain paths globally
    ignores = [
      "*.localcargo/"
      "*.direnv/"
      "*.localzoxide/"
      "*.localgomod/"
      "*.localgocache/"
      "*.localgohome/"
      "*.aider*"
    ];
    # Enable syntax highlight in diffs
    difftastic.enable = true;
    difftastic.display = "inline";
  };
}
