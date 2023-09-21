{ pkgs }: rec {
  core = with pkgs; [ git tree-sitter nodejs gcc ripgrep fd trashy ];
  language-servers = with pkgs; [
    nodePackages.vscode-langservers-extracted
    efm-langserver
    lua-language-server
    nodePackages.pyright
    taplo
    nodePackages.svelte-language-server
    nodePackages.yaml-language-server
    nil
    nodePackages.dockerfile-language-server-nodejs
    nodePackages."@tailwindcss/language-server"
    nodePackages.bash-language-server
  ];
  formatters = with pkgs; [ black prettierd nixpkgs-fmt shfmt ];
  linters = with pkgs; [ ruff-lsp dotenv-linter editorconfig-checker shellcheck ];

  all = core ++ language-servers ++ formatters ++ linters;
}

