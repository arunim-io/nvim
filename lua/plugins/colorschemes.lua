return {
  {
    "EdenEast/nightfox.nvim",
    enabled = false,
    lazy = false,
    priority = 1000,
    init = function()
      vim.cmd("colorscheme terafox")
    end,
    opts = {
      options = { dim_inactive = true },
    },
  },
  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
    init = function()
      vim.cmd("colorscheme cyberdream")
    end,
    opts = {
      italic_comments = true,
      hide_fillchars = true,
    },
  },
}
