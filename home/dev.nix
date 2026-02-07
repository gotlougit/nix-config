{ pkgs, inputs, ... }:

{
  # Misc packages for dev work that come in handy
  home.packages = with pkgs; [
    # ghidra # Decompiler
    # claude-code # Claude in the terminal
    # gemini-cli # Gemini in the terminal
    llm-agents.codex # ChatGPT in the terminal
    llm-agents.opencode # Open source coding agent
    # llama-cpp # Run local LLMs efficiently on CPU/GPU
    llm-agents.amp # Opinionated coding agent with numerous tools
    inputs.kimi.packages.${pkgs.stdenv.hostPlatform.system}.default # kimi-cli

    mitmproxy # Inspect everything
    proxychains-ng # Proxy everything
  ];
}
