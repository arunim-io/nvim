local gitsigns = require("gitsigns")

gitsigns.setup({
  on_attach = function(bufnr)
    local function map(mode, keymap, action, desc)
      vim.keymap.set(mode, keymap, action, { buffer = bufnr, desc = "[G]it " .. desc })
    end

    map("n", "<leader>ggs", gitsigns.stage_hunk, "[S]tage hunk")
    map("v", "<leader>ggs", function()
      gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, "[S]tage hunk on select")

    map("n", "<leader>ggr", gitsigns.reset_hunk, "[R]eset hunk")
    map("v", "<leader>ggr", function()
      gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, "[R]est hunk on select")

    map("n", "<leader>ggS", gitsigns.stage_buffer, "[S]tage buffer")
    map("n", "<leader>ggR", gitsigns.reset_buffer, "[R]eset buffer")

    map("n", "<leader>ggu", gitsigns.undo_stage_hunk, "[U]ndo stage hunk")
    map("n", "<leader>ggp", gitsigns.preview_hunk, "[P]review current hunk")

    map("n", "<leader>ggbb", function()
      gitsigns.blame_line({ full = true })
    end, "[B]lame current changes")
    map("n", "<leader>ggbt", gitsigns.toggle_current_line_blame, "[B]lame changes in current line")

    map("n", "<leader>ggd", gitsigns.diffthis, "[D]iff current file")
    map("n", "<leader>ggD", function()
      gitsigns.diffthis("~")
    end, "[D]iff current git repo")

    map("n", "<leader>ggtd", gitsigns.toggle_deleted, "[T]oggle [D]elete")
  end,
})

local neogit = require("neogit")

neogit.setup({
  telescope_sorter = function()
    require("telescope").extensions.fzf.native_fzf_sorter()
  end,
  mappings = {
    status = {
      ["<c-s>"] = false,
      ["a"] = "StageAll",
    },
  },
})

vim.keymap.set("n", "<leader>ggv", function()
  neogit.open({ cwd = vim.fn.expand("%:p:h") })
end, { desc = "Show [G]it [S]tatus" })
