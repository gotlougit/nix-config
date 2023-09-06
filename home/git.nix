{ ... }:

{
  programs.git = {
    enable = true;
    userName = "Saksham Mittal";
    userEmail = "gotlouemail@gmail.com";
    # Signing config
    extraConfig = {
      gpg.format = "ssh";
      user.signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINdqk3Yo5e67SNiTiZlIMlDHI5cD9L3hFatrFo+yM7zB signing-key";
      commit.gpgsign = true;
      init.defaultBranch = "main";
      diff.renames = "copy";
      core.autocrlf = "input";
      core.autoclrf = false;
      core.filemode = false;
      push.default = "current";
      gpg.ssh.allowedSignersFile = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINdqk3Yo5e67SNiTiZlIMlDHI5cD9L3hFatrFo+yM7zB signing-key";
    };
    # Enable syntax highlight in diffs
    delta.enable = true;
  };
}
