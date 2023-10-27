return {
  {
    "EdenEast/nightfox.nvim",
    config = true,
    init = function() vim.cmd "colorscheme carbonfox" end,
    opts = {
      options = {
        dim_inactive = true,
      },
    },
  },
  -- Status bar
  {
    'nvim-lualine/lualine.nvim',
    dependencies = 'nvim-tree/nvim-web-devicons',
    opts = {
      globalstatus = true,
    },
  },
}
