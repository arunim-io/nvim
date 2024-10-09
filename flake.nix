{
  description = "Arunim's Neovim config, configured using NixCats-nvim.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
    treefmt.url = "github:numtide/treefmt-nix";
    nixCats.url = "github:BirdeeHub/nixCats-nvim?dir=nix";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    gh-actions = {
      url = "github:nix-community/nix-github-actions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plugins-cmp-luasnip = {
      url = "github:saadparwaiz1/cmp_luasnip";
      flake = false;
    };
    plugins-nvim-puppeteer = {
      url = "github:chrisgrieser/nvim-puppeteer";
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
      dependencyOverlays = [ (utils.standardPluginOverlay inputs) ];

      categoryDefinitions =
        { pkgs, ... }:
        {
          propagatedBuildInputs = with pkgs; { };

          lspsAndRuntimeDeps = with pkgs; {
            base = [ ripgrep ];
            git = [ git ];
            integrations.tmux = [
              tmux
              tmux-sessionizer
            ];
            telescope = [
              ripgrep
              fd
            ];
            language-support = {
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
                nil
                vscode-langservers-extracted
                yaml-language-server
                basedpyright
                ruff
                htmx-lsp
                emmet-language-server
                basedpyright
                svelte-language-server
                astro-language-server
                tailwindcss-language-server
                biome
                taplo
                typescript
                rust-analyzer
                gopls
                gofumpt
                golangci-lint
                golines
                gotools
                gomodifytags
                gotests
                gotestsum
                iferr
                impl
                reftools
                ginkgo
                richgo
                govulncheck
              ];
              formatters = [
                prettierd
                nixfmt-rfc-style
                stylua
                djlint
              ];
              linters = [
                selene
                djlint
              ];
            };
          };

          startupPlugins = with pkgs.vimPlugins; {
            base = [
              plenary-nvim
              lualine-nvim
              which-key-nvim
              mini-icons
              mini-files
              indent-blankline-nvim
              rainbow-delimiters-nvim
              nvim-autopairs
            ];
            git = [
              gitsigns-nvim
              neogit
              diffview-nvim
              cmp-git
            ];
            integrations.tmux = [ tmux-nvim ];
            telescope = [
              telescope-nvim
              telescope-fzf-native-nvim
              telescope-ui-select-nvim
            ];
            language-support = {
              treesitter = [
                nvim-treesitter.withAllGrammars
                nvim-treesitter-textobjects
                nvim-ts-autotag
                helpview-nvim
                markview-nvim
                pkgs.neovimPlugins.nvim-puppeteer
                otter-nvim
              ];
              lsp = [
                nvim-lspconfig
                trouble-nvim
                cmp-nvim-lsp
                SchemaStore-nvim
                fidget-nvim
                typescript-tools-nvim
                tailwind-tools-nvim
                rustaceanvim
                go-nvim
              ];
              completion = [
                nvim-cmp
                cmp-buffer
                cmp-path
                cmp-cmdline
              ];
              snippets = [
                luasnip
                friendly-snippets
                pkgs.neovimPlugins.cmp-luasnip
              ];
              formatters = [ conform-nvim ];
              linters = [ nvim-lint ];
            };
          };

          optionalPlugins = with pkgs.vimPlugins; {
            language-support.lsp = [
              lazydev-nvim
              luvit-meta
            ];
          };

          sharedLibraries = { };

          environmentVariables = { };

          extraWrapperArgs = { };

          extraPython3Packages = { };
          extraLuaPackages = { };
        };

      defaultPackageName = "anc";

      packageDefinitions = {
        ${defaultPackageName} =
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
              extras.nixpkgs = nixpkgs.outPath;
              base = true;
              git = true;
              integrations.tmux = true;
              telescope = true;
              language-support = {
                treesitter = true;
                lsp = true;
                completion = true;
                snippets = true;
                formatters = true;
                linters = true;
              };
            };
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
          checks = nixpkgs.lib.getAttrs [
            "x86_64-linux"
            "x86_64-darwin"
          ] self.checks;
        };
      }
    );

  nixConfig = {
    extra-substituters = [ "https://arunim.cachix.org" ];
    extra-trusted-public-keys = [ "arunim.cachix.org-1:J07zWDguRFHQSio/VmTT8us5EelRNlDTFkbNeFel0xM=" ];
  };
}
