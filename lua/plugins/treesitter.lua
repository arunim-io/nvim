return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = function() require("nvim-treesitter.install").update({ with_sync = true })() end,
    config = function(_, opts) require('nvim-treesitter.configs').setup(opts) end,
    opts = {
      sync_install = true,
      highlight = { enable = true },
      indent = { enable = true },
      ensure_installed={"bash","css","dockerfile","fish","html","htmldjango","javascript","jsdoc","json","jsonc","lua","nix","python","regex","rust","scss","ssh_config","svelte","toml","tsx","typescript","vim","yaml"},
    },
  },
}
