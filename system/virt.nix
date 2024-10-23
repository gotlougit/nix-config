{ pkgs, ... }:

{
  # Enable virtualization
  virtualisation.libvirtd.enable = true;
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
}
