--- @type LazySpec
return {
  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    opts = {
      on_attach = function(bufnr)
        local gitsigns = require("gitsigns")

        local function map(mode, keymap, action, desc)
          vim.keymap.set(mode, keymap, action, { buffer = bufnr, desc = "[G]it: " .. desc })
        end

        map("n", "<leader>gs", gitsigns.stage_hunk, "[S]tage hunk")
        map("v", "<leader>gs", function()
          gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "[S]tage hunk on select")

        map("n", "<leader>gr", gitsigns.reset_hunk, "[R]eset hunk")
        map("v", "<leader>gr", function()
          gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "[R]est hunk on select")

        map("n", "<leader>gS", gitsigns.stage_buffer, "[S]tage buffer")
        map("n", "<leader>gR", gitsigns.reset_buffer, "[R]eset buffer")

        map("n", "<leader>gu", gitsigns.undo_stage_hunk, "[U]nstage hunk")
        map("n", "<leader>gp", gitsigns.preview_hunk, "[P]review current hunk")

        map("n", "<leader>gb", function()
          gitsigns.blame_line({ full = true })
        end, "[B]lame current changes")
        map("n", "<leader>gB", gitsigns.toggle_current_line_blame, "[B]lame changes in current line")

        map("n", "<leader>gd", gitsigns.diffthis, "[D]iff current file")
        map("n", "<leader>gD", function()
          gitsigns.diffthis("~")
        end, "[D]iff current git repo")

        map("n", "<leader>gtd", gitsigns.toggle_deleted, "[T]oggle [D]elete")
      end,
    },
  },
  {
    "echasnovski/mini.diff",
    version = false,
    event = "VeryLazy",
    config = true,
    keys = {
      {
        "<leader>go",
        function()
          require("mini.diff").toggle_overlay(0)
        end,
        desc = "Toggle mini.diff overlay",
      },
    },
  },
}
