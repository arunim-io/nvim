return {
  "stevearc/oil.nvim",
  dependencies = "nvim-tree/nvim-web-devicons",
  lazy = false,
  keys = {
    { "<leader>pv", "<cmd>Oil<cr>", desc = "Switch to Oil" },
  },
  opts = {
    delete_to_trash = true,
    experimental_watch_for_changes = false,
    skip_confirm_for_simple_edits = true,
    lsp_file_methods = {
      autosave_changes = true,
    },
    view_options = {
      show_hidden = true,
    },
  },
}
