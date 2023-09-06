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
    };
    # Enable syntax highlight in diffs
    delta.enable = true;
  };
}
