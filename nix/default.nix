{ pkgs, neovim }:
let
  packages = import ./packages.nix { inherit pkgs; };
in
pkgs.symlinkJoin {
  name = "neovim";
  paths = [ neovim ] ++ packages.all;
}

