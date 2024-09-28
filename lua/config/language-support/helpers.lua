local trouble = require("trouble")

trouble.setup({})

vim.keymap.set("n", "<leader>dl", vim.diagnostic.open_float, { desc = "Show [D]iagnostics for current buffer line" })

vim.keymap.set("n", "<leader>dd", function()
  trouble.toggle({
    mode = "diagnostics",
    filter = { buf = 0 },
  })
end, { desc = "Show [D]iagnostics for current buffer" })
vim.keymap.set("n", "<leader>dw", function()
  trouble.toggle("diagnostics")
end, { desc = "Show [D]iagnostics for current [W]orkspace" })

require("fidget").setup({})

local otter = require("otter")

otter.setup({
  buffers = {
    set_filetype = true,
    write_to_disk = true,
  },
})

vim.api.nvim_create_user_command("OtterActivate", function()
  require("otter").activate()
end, { desc = "Activate otter" })
