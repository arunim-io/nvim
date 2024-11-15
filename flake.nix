{
  description = "Arunim's Neovim config, configured using NixCats-nvim.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    systems.url = "github:nix-systems/default";

    treefmt = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixCats.url = "github:BirdeeHub/nixCats-nvim";

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vscode-langservers-extracted.url = "github:arunim-io/vscode-langservers-extracted";

    gh-actions = {
      url = "github:nix-community/nix-github-actions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plugins-snacks-nvim = {
      url = "github:folke/snacks.nvim";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      systems,
      treefmt,
      nixCats,
      neovim-nightly-overlay,
      gh-actions,
      ...
    }@inputs:
    let
      inherit (nixCats) utils;
      luaPath = "${./.}";
      eachSystem = utils.eachSystem (import systems);
      extra_pkg_config = { };
      dependencyOverlays = [
        (utils.standardPluginOverlay inputs)
        inputs.vscode-langservers-extracted.overlays.default
      ];

      categoryDefinitions =
        { pkgs, ... }:
        {
          propagatedBuildInputs = with pkgs; { };

          lspsAndRuntimeDeps = with pkgs; {
            core = [ ripgrep ];
            git = [ git ];
            tmux = [
              tmux
              tmux-sessionizer
            ];
            telescope = [
              ripgrep
              fd
            ];
            treesitter = [
              gnutar
              curl
              git
              tree-sitter
              nodejs_latest
              zig
            ];
            lsp = [
              lua-language-server
              nixd
              vscode-langservers-extracted
              yaml-language-server
              basedpyright
              ruff
              taplo-lsp
              emmet-language-server
              astro-language-server
              svelte-language-server
              htmx-lsp
              gopls
              rust-analyzer
            ];
            formatting = [
              prettierd
              stylua
              djlint
              nixfmt-rfc-style
              gofumpt
              gotools
            ];
            linting = [
              selene
              djlint
            ];
          };

          startupPlugins = with pkgs.vimPlugins; {
            core = [
              plenary-nvim
              lazy-nvim
              pkgs.neovimPlugins.snacks-nvim
            ];
            editor = [
              which-key-nvim
              mini-files
              trouble-nvim
              mini-pairs
              ts-comments-nvim
              mini-ai
              grug-far-nvim
              todo-comments-nvim
              mini-comment
              mini-surround
            ];
            ui = [
              mini-icons
              lualine-nvim
              indent-blankline-nvim
              rainbow-delimiters-nvim
              fidget-nvim
            ];
            telescope = [
              telescope-nvim
              telescope-fzf-native-nvim
            ];
            treesitter = [
              nvim-treesitter.withAllGrammars
              nvim-ts-autotag
              nvim-ts-context-commentstring
            ];
            lsp = [
              nvim-lspconfig
            ];
            completion = [
              blink-cmp
              friendly-snippets
            ];
            formatting = [ conform-nvim ];
            linting = [ nvim-lint ];
            git = [ ];
          };

          optionalPlugins = with pkgs.vimPlugins; {
            core = [ ];
            editor = [ ];
            ui = [ ];
            git = [ ];
            telescope = [ ];
            treesitter = [ ];
            lsp = [
              SchemaStore-nvim
              lazydev-nvim
              luvit-meta
              crates-nvim
              rustaceanvim
            ];
            completion = [ ];
            formatting = [ ];
            tmux = [ tmux-nvim ];
          };

          sharedLibraries = { };

          environmentVariables = { };

          extraWrapperArgs = { };

          extraPython3Packages = { };
          extraLuaPackages = { };
        };

      defaultPackageName = "anc";

      packageDefinitions.${defaultPackageName} =
        { pkgs, ... }:
        {
          settings = {
            wrapRc = true;
            aliases = [
              "nvim"
              "vim"
              "vi"
            ];
            neovim-unwrapped = neovim-nightly-overlay.packages.${pkgs.system}.neovim;
          };
          categories = {
            core = true;
            editor = true;
            ui = true;
            telescope = true;
            treesitter = true;
            lsp = true;
            completion = true;
            formatting = true;
            linting = true;
            git = true;
            tmux = true;
          };
        };
    in

    eachSystem (
      system:
      let
        builder = utils.baseBuilder luaPath {
          inherit
            nixpkgs
            system
            dependencyOverlays
            extra_pkg_config
            ;
        } categoryDefinitions packageDefinitions;
        defaultPackage = builder defaultPackageName;
        pkgs = import nixpkgs { inherit system; };
        treefmtEval = treefmt.lib.evalModule pkgs ./treefmt.nix;
      in
      {
        packages = utils.mkAllWithDefault defaultPackage;

        formatter = treefmtEval.config.build.wrapper;

        checks.${defaultPackageName} = self.packages.${system}.default;
      }
    )
    // (
      let
        builderArgs = {
          inherit nixpkgs dependencyOverlays extra_pkg_config;
        };
        moduleArgs = builderArgs // {
          inherit
            defaultPackageName
            luaPath
            categoryDefinitions
            packageDefinitions
            ;
        };
      in
      {
        overlays =
          utils.makeOverlays luaPath builderArgs categoryDefinitions packageDefinitions
            defaultPackageName;

        nixosModules.default = utils.mkNixosModules moduleArgs;
        homeManagerModules.default = utils.mkHomeModules moduleArgs;

        inherit utils;
        inherit (utils) templates;

        githubActions = gh-actions.lib.mkGithubMatrix {
          checks = nixpkgs.lib.getAttrs [ "x86_64-linux" ] self.checks;
        };
      }
    );

  nixConfig = {
    extra-substituters = [ "https://arunim.cachix.org" ];
    extra-trusted-public-keys = [ "arunim.cachix.org-1:J07zWDguRFHQSio/VmTT8us5EelRNlDTFkbNeFel0xM=" ];
  };
}
