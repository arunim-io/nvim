{ inputs }:
{ pkgs, ... }:
{
  config.programs.neovim = {
    package = inputs.nightly-overlay.${pkgs.system}.default;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withPython3 = false;
    withRuby = false;
    extraPackages =
      let
        LSPkgs = with pkgs; [
          # nix
          nil
          nixfmt-rfc-style
          statix
          # lua
          lua-language-server
          selene
          stylua
          # html,css,json
          vscode-langservers-extracted
          emmet-language-server
          # shell
          nodePackages.bash-language-server
          shfmt
          shellcheck
          # dockerfile
          dockerfile-language-server-nodejs
          # python
          python312
          pyright
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
          typescript
          # multi-lang formatter
          prettierd
          # toml
          taplo
          # yaml
          yaml-language-server
        ];

        systemPkgs = with pkgs; [
          ripgrep
          fd
          fzf
          wl-clipboard
          gcc
          luajit
          gnumake
          unzip
          xdg-utils
        ];
      in
      systemPkgs ++ LSPkgs;
  };
}
