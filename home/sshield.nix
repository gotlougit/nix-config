{
  xdg.configFile."sshield/sshield.toml".text = ''
    database = "/persist/sensitive/sshield-db.db3"
    prompt = 60
    keyring = true
  '';
}
