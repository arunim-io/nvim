return {
  {
    "EdenEast/nightfox.nvim",
    config=true,
    init = function() vim.cmd "colorscheme nightfox" end,
    opts = {
      options = {
        transparent = true,
        dim_inactive = true,
      },
    },
  }
}
