{ pkgs, lib, ... }:

{
  # Enable virtualization
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  programs.virt-manager.enable = true;
  # Enable dconf for settings
  programs.dconf.enable = true;
  # Enable IPv4 forwarding so networking works right in NATted VMs
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
  # Enable docker
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };
  environment.systemPackages = with pkgs; [ quickemu ];

  # Allow gotlou to manage microvm@*.service without sudo
  security.polkit.extraConfig = lib.mkAfter ''
    polkit.addRule(function(action, subject) {
        if (subject.user == "gotlou" &&
            action.id == "org.freedesktop.systemd1.manage-units") {
            var unit = action.lookup("unit");
            var verb = action.lookup("verb");
            if (unit && unit.match(/^microvm@.*\.service$/) &&
                (verb == "start" || verb == "stop" || verb == "restart")) {
                return polkit.Result.YES;
            }
        }
    });
  '';
}
