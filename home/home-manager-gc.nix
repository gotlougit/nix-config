{ pkgs, ... }:

{
  systemd.user.services.home-manager-gc = {
    Unit = {
      Description = "Clean up old home-manager generations";
    };

    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash ${./clean-old-generations.sh}";
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
}

