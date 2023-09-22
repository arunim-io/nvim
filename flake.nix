{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    neovim = {
      url = "github:neovim/neovim?dir=contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ flake-parts, neovim, ... }: flake-parts.lib.mkFlake { inherit inputs; } {
    systems = [ "x86_64-linux" ];
    perSystem = { pkgs, config, system, ... }: {
      packages =
        let
          args = {
            inherit pkgs;
            inherit (neovim.packages.${system}) neovim;
          };
        in
        {
          default = import ./nix args;
          extras = import ./nix/packages.nix args;
        };
      apps.default = {
        type = "app";
        program = "${config.packages.default}/bin/nvim";
      };
    };

    flake.hm = {
      enable = true;
      package = inputs.self.packages.default;
      extraPackages = inputs.self.packages.extras;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      withNodeJs = true;
      withPython3 = true;
      withRuby = false;
    };
  };
}

