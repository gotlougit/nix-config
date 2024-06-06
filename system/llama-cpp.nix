{ lib, ... }:

{
  services.llama-cpp = {
    enable = true;
    model = "/persist/dotfiles/llama/llava-llama-3-8b-v1_1-int4.gguf";
    extraFlags = [
      "-ngl"
      "20"
    ];
  };
  systemd.services.llama-cpp.serviceConfig = {
    DynamicUser = lib.mkForce false;
    User = "gotlou";
  };
}
