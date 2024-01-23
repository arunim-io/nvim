{ config, pkgs, lib, ... }: with lib; {
  options.programs.nvim = {
    enable = mkEnableOption "nvim";

    package = mkOption {
      type = types.package;
      default = pkgs.neovim;
      defaultText = literalExpression "pkgs.neovim";
      description = "The package to use for nvim";
    };
  };

  config =
    let
      inherit (config.programs.nvim) enable package;

      defaultPkgs = import ./pkgs.nix { inherit pkgs; };
    in
    {
      home.packages = defaultPkgs;
      programs.neovim = {
        inherit enable package;

        extraPackages = defaultPkgs;
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;
      };
    };
}
