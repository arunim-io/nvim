{
  outputs = { self, ... }: {
    homeManagerModules = {
      default = self.homeManagerModules.nvim;
      nvim = import ./module.nix;
    };
  };
}
