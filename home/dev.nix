{ pkgs, inputs, ... }:

let
  llmPkgs = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  # Misc packages for dev work that come in handy
  home.packages = with pkgs; [
    # ghidra # Decompiler

    # LLM coding agents
    llmPkgs.codex # ChatGPT in the terminal
    # llmPkgs.amp # Opinionated coding agent with numerous tools
    llmPkgs.pi # THE original minimal coding agent
    codex-auth # Multi-account helper for Codex
    src-cli # Sourcegraph CLI

    # Local/on-device LLMs
    litert-lm # Google's on-device LLM inference CLI
    # llama-cpp # Run local LLMs efficiently on CPU/GPU -- commented out for now

    # Other coding agents from other flakes
    dirge # minimal coding agent with tool call healing
    # inputs.ik_llama.packages.${pkgs.stdenv.hostPlatform.system}.default

    mitmproxy # Inspect everything
    proxychains-ng # Proxy everything
    nsproxy

    # Useful for scripting
    python3
    uv
  ];

}
