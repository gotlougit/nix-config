{ ... }:

let
  userName = "Saksham Mittal";
  userEmail = "git@gotlou.com";
  signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINdqk3Yo5e67SNiTiZlIMlDHI5cD9L3hFatrFo+yM7zB";
  signingIdentity = "git@gotlou.com";
in
{
  home.file.".config/jj/allowed-signers".text = ''
    ${signingIdentity} ${signingKey}
  '';

  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = userName;
        email = userEmail;
      };

      signing = {
        behavior = "own";
        backend = "ssh";
        key = signingKey;
        backends.ssh.allowed-signers = "~/.config/jj/allowed-signers";
      };
    };
  };
}
