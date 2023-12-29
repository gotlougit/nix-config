{ inputs, ... }:
{
  imports = [ inputs.sshield.hmModule ];
  programs.sshield = {
    enable = true;
    settings = {
      database = "/persist/sensitive/sshield-db.db3";
      prompt = 60;
      keyring = true;
    };
  };
}
