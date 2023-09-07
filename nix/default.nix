{ pkgs, neovim }: pkgs.symlinkJoin {
  name = "neovim";
  paths = [ neovim ];
}

