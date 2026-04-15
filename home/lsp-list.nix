{ pkgs }:

with pkgs;
[
  llvmPackages_18.clang-tools # C/C++
  rust-analyzer # Rust
  gopls # Golang
  bash-language-server # Bash
  dockerfile-language-server # Dockerfile
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
  typescript-language-server
  prettier

  # Nix
  nil
  nixfmt
  nixd
]
