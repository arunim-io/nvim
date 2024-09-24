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
      self,
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
        {
          pkgs,
          settings,
          categories,
          name,
          ...
        }:
        {
          propagatedBuildInputs = with pkgs; { };

          lspsAndRuntimeDeps = with pkgs; {
            base = [ ripgrep ];
            language-support.treesitter = [
              gnutar
              curl
              git
              tree-sitter
              nodejs_latest
              zig
            ];
          };

          startupPlugins = with pkgs.vimPlugins; {
            base = [ ];
            language-support.treesitter = [
              nvim-treesitter.withAllGrammars
              nvim-treesitter-textobjects
              nvim-ts-autotag
            ];
          };

          optionalPlugins = {
            base = with pkgs.vimPlugins; [ ];
          };

          sharedLibraries = {
            base = with pkgs; [
              # libgit2
            ];
          };

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
              base = true;
              language-support.treesitter = true;
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
