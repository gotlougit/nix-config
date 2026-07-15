{ inputs, ... }:
{
  imports = [ inputs.lightpanda.nixosModules.default ];
  services.lightpanda.enable = true;
  services.lightpanda.settings = {
    host = "127.0.0.1";
    port = 9333;
    logLevel = "info";
  };
}
