require("mini.ai").setup()
require("mini.pairs").setup()
require("mini.splitjoin").setup()
require("mini.surround").setup()
require("mini.bracketed").setup()

require("mini.comment").setup({
  options = {
    custom_commentstring = function()
      return require("ts_context_commentstring").calculate_commentstring() or vim.bo.commentstring
    end,
  },
})

local mini_files = require("mini.files")

mini_files.setup({
  options = { use_as_default_explorer = true },
  mappings = {
    synchronize = "s",
    go_in = "<Right>",
    go_out = "<Left>",
    go_in_plus = "",
    go_out_plus = "",
  },
})

vim.keymap.set("n", "<leader>pv", function()
  mini_files.open()
end, { desc = "Show files explorer" })

MiniDeps.add("folke/which-key.nvim")

require("which-key").setup({
  preset = "helix",
})

MiniDeps.add("MagicDuck/grug-far.nvim")

local grug_far = require("grug-far")

grug_far.setup()

vim.keymap.set({ "n", "v" }, "<leader>rw", function()
  local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")

  grug_far.open({
    transient = true,
    prefills = { filesFilter = ext and ext ~= "" and "*." .. ext or nil },
  })
end, { desc = "Search & replace" })
