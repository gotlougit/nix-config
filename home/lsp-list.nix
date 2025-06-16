{ pkgs }:

with pkgs; [
  llvmPackages_18.clang-tools # C/C++
  rust-analyzer # Rust
  gopls # Golang
  nodePackages.bash-language-server # Bash
  dockerfile-language-server-nodejs # Dockerfile
  vscode-langservers-extracted # HTML/CSS/JSON
  texlab # LaTEX
  protols # protobuf

  # Python
  python312Packages.python-lsp-server
  ruff

  # Markdown
  markdown-oxide
  marksman

  # TS/JS
  nodePackages.typescript-language-server
  nodePackages.prettier

  # Nix
  nixfmt-classic
  nixd
]
