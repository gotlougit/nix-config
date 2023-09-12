{ ... }:

{
  # Enable virtualization
  virtualisation.libvirtd.enable = true;
  # Enable IPv4 forwarding so networking works right in NATted VMs
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
  # Enable podman
  virtualisation.podman = {
    enable = true;

    # Create a `docker` alias for podman, to use it as a drop-in replacement
    dockerCompat = true;

    # Required for containers under podman-compose to be able to talk to each other.
    defaultNetwork.settings = {
      dns_enabled = true;
    };
  };
}
