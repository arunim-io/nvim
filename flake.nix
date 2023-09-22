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
    perSystem = { pkgs, system, config, ... }: {
      packages.default = neovim.packages.${system}.neovim;
      apps.default = {
        type = "app";
        program = "${config.packages.default}/bin/nvim";
      };
    };
  };
}

