{ pkgs ? import <nixpkgs> { } }: with pkgs; [
  # neovim related
  tree-sitter
  fd
  ripgrep
  gcc
  gnumake
  # nix
  nil
  nixpkgs-fmt
  statix
  # lua
  lua-language-server
  selene
  stylua
  # html,css,json
  vscode-langservers-extracted
  # shell
  nodePackages.bash-language-server
  shfmt
  shellcheck
  # dockerfile
  dockerfile-language-server-nodejs
  # python
  python3
  nodePackages.pyright
  ruff
  ruff-lsp
  black
  # javascript
  nodejs_20
  corepack_20
  typescript
  nodePackages.svelte-language-server
  nodePackages.typescript-language-server
  nodePackages."@astrojs/language-server"
  nodePackages."@tailwindcss/language-server"
  biome
  # multi-lang formatter
  nodePackages.prettier
  # toml
  taplo
]
