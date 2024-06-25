require("gitsigns").setup()

local neogit = require("neogit")

neogit.setup()

vim.keymap.set("n", "<leader>gg", neogit.open, { desc = "Open NeoGit" })
