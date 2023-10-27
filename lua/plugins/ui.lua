return {
  {
    "EdenEast/nightfox.nvim",
    config=true,
    init = function() vim.cmd "colorscheme carbonfox" end,
    opts = {
      options = {
        dim_inactive = true,
      },
    },
  }
}
