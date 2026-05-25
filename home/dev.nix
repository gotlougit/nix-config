{ pkgs, inputs, ... }:

{
  # Misc packages for dev work that come in handy
  home.packages = with pkgs; [
    # ghidra # Decompiler
    # claude-code # Claude in the terminal
    # gemini-cli # Gemini in the terminal
    llm-agents.codex # ChatGPT in the terminal
    codex-auth # Multi-account helper for Codex
    src-cli # Sourcegraph CLI
    # llm-agents.opencode # Open source coding agent
    # llama-cpp # Run local LLMs efficiently on CPU/GPU
    litert-lm # Google's on-device LLM inference CLI
    # llm-agents.amp # Opinionated coding agent with numerous tools
    # inputs.kimi.packages.${pkgs.stdenv.hostPlatform.system}.default # kimi-cli
    llm-agents.pi
    inputs.tau.packages.${pkgs.stdenv.hostPlatform.system}.default

    mitmproxy # Inspect everything
    proxychains-ng # Proxy everything
    nsproxy
  ];
}
