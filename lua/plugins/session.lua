---@type LazySpec
return {
  {
    "rmagatti/auto-session",
    dependencies = { "nvim-telescope/telescope.nvim" },
    init = function()
      vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
    end,
    opts = {
      auto_save_enabled = true,
      auto_restore_enabled = true,
    },
  },
}
