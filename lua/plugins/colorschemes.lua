local nightfox = {
  "EdenEast/nightfox.nvim",
  lazy = false,
  priority = 1000,
  init = function()
    vim.cmd("colorscheme terafox")
  end,
  opts = {
    options = {
      dim_inactive = true,
    },
  },
}

return { nightfox }
