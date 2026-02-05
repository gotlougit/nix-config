{ inputs, ... }:
let
  microvm = inputs.microvm;
in
{
  # Define microvms
  microvm.vms.coder = {
    autostart = false;
    config = {
      imports = [
        microvm.nixosModules.microvm
        (import ./microvm-base.nix {
          hostName = "coder";
          ipAddress = "192.168.83.2";
          tapId = "microvm0";
          mac = "02:00:00:00:00:01";
          workspace = "/home/gotlou/virt-machines/microvm/coder";
          inherit inputs;
        })
      ];
    };
  };
}
