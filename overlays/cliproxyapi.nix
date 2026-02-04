# ref: https://github.com/xddxdd/nur-packages/blob/master/pkgs/uncategorized/cliproxyapi/default.nix
{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule (finalAttrs: {
  pname = "cliproxyapi";
  version = "v6.7.46";
  src = fetchFromGitHub {
    owner = "router-for-me";
    repo = "CLIProxyAPI";
    tag = "v6.7.46";
    hash = "sha256-21OUW4GhOB6peFmX4meWwTeUFC+7pS3us3sLyktz1Kc=";
  };

  vendorHash = "sha256-jNcIsMBGFKYn1fwUlLSjfLEHskQnvtBd40e+mD3a10c=";

  proxyVendor = true;

  ldflags = [
    "-s"
    "-w"
  ];

  doCheck = false;

  meta = {
    maintainers = with lib.maintainers; [ xddxdd ];
    description = "Wrap Gemini CLI, Antigravity, ChatGPT Codex, Claude Code, Qwen Code, iFlow as an OpenAI/Gemini/Claude/Codex compatible API service";
    homepage = "https://github.com/router-for-me/CLIProxyAPI";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "server";
  };
})
