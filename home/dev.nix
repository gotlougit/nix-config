{ pkgs, ... }:

{
  # Misc packages for dev work that come in handy
  home.packages = with pkgs; [
    # ghidra # Decompiler
    claude-code # Claude in the terminal
    # gemini-cli # Gemini in the terminal
    libra # Antigravity in the terminal
    codex # ChatGPT in the terminal
    # llama-cpp # Run local LLMs efficiently on CPU/GPU
    amp-cli # Opinionated coding agent with numerous tools

    mitmproxy # Inspect everything
    proxychains-ng # Proxy everything

    autodevenv
  ];
}
