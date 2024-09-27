{
  description = "Arunim's Neovim config, configured using NixCats-nvim.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim?dir=nix";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    systems.url = "github:nix-systems/default";
  };

  outputs =
    {
      nixpkgs,
      systems,
      nixCats,
      ...
    }@inputs:
    let
      inherit (nixCats) utils;
      luaPath = "${./.}";
      eachSystem = utils.eachSystem (import systems);
      extra_pkg_config = { };
      dependencyOverlays = eachSystem (system: {
        dependencyOverlays = [ (utils.standardPluginOverlay inputs) ];
      });

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
              ];
              formatters = [
                prettierd
                nixfmt-rfc-style
                stylua
              ];
              linters = [ ];
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
              ];
              lsp = [
                nvim-lspconfig
                trouble-nvim
              ];
              completion = [
                nvim-cmp
                cmp-nvim-lsp
                cmp-buffer
                cmp-path
                cmp-cmdline
              ];
              formatters = [ conform-nvim ];
              linters = [ nvim-lint ];
            };
          };

          optionalPlugins = with pkgs.vimPlugins; {
            language-support.lsp = [ lazydev-nvim ];
          };

          sharedLibraries = { };

          environmentVariables = { };

          extraWrapperArgs = { };

          extraPython3Packages = { };
          extraLuaPackages = { };
        };

      packageDefinitions = {
        nvim =
          { pkgs, ... }:
          {
            settings = {
              wrapRc = true;
              aliases = [
                "vim"
                "vi"
              ];
              neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;
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
                formatters = true;
                linters = true;
              };
            };
          };
      };
      defaultPackageName = "nvim";
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
      in
      {
        packages = utils.mkAllWithDefault defaultPackage;

        devShells.default = pkgs.mkShell {
          name = defaultPackageName;
          packages = [ defaultPackage ];
          inputsFrom = [ ];
          shellHook = '''';
        };
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
      }
    );

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
}
