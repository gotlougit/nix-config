{ pkgs, ... }:
{
  xdg.configFile."sshield/sshield.toml".text = ''
    database = "/persist/sensitive/sshield-db.db3"
    prompt = 60
    keyring = true
  '';
  systemd.user.services.sshield = {
    Unit = {
      Description = "Secure SSH agent written in Rust";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
    Service = {
      ExecStart = "${pkgs.writeShellScript "sshield-serve" ''
        #!/run/current-system/sw/bin/bash
        sshield serve
      ''}";
      ExecStop = "${pkgs.writeShellScript "sshield-stop" ''
        #!/run/current-system/sw/bin/bash
        rm "$XDG_RUNTIME_DIR"/ssh-agent
      ''}";
      User = "gotlou";
      PrivateUsers = true;
      LockPersonality = true;
      PrivateNetwork = true;
      MemoryDenyWriteExecute = true;
      NoNewPrivileges = true;
      ProtectSystem = "strict";
      PrivateMounts = true;
      PrivateTmp = true;
      ProtectClock = true;
      ProtectControlGroups = true;
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      RestrictNamespaces = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      RestrictAddressFamilies = [ "AF_UNIX" ];
      SystemCallArchitectures = "native";
      PrivateDevices = true;
      SystemCallFilter = [ "@system-service" "~@privileged"];
    };
  };

}
