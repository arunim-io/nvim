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
      packages = {
        default = import ./nix {
          inherit pkgs;
          inherit (neovim.packages.${system}) neovim;
        };
        extras = import ./nix/packages.nix { inherit pkgs; };
      };
      apps.default = {
        type = "app";
        program = "${config.packages.default}/bin/nvim";
      };
    };
  };
}

