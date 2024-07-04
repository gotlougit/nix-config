{ ... }: {
  time.timeZone = "Asia/Kolkata";
  networking.hostName = "mimir";
  users = {
    users.gotlou = {
      password = "myPassword";
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };
  };
  system.stateVersion = "22.11";
}
