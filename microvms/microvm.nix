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
          tapId = "microvm0";
          mac = "02:00:00:00:00:01";
          inherit inputs;
        })
      ];
    };
  };
}
