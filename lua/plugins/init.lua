---@type LazySpec
return {
  { "nvim-lua/plenary.nvim", lazy = true },
  { "stevearc/dressing.nvim", config = true },
  {
    "echasnovski/mini.icons",
    config = true,
    specs = {
      { "nvim-tree/nvim-web-devicons", enabled = false, optional = true },
    },
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },
  {
    "stevearc/oil.nvim",
    enabled = false,
    dependencies = "echasnovski/mini.icons",
    keys = {
      { "<leader>pv", "<cmd>Oil<cr>", desc = "Show file explorer" },
    },
    opts = {
      skip_confirm_for_simple_edits = true,
      lsp_file_methods = { autosave_changes = true },
      watch_for_changes = true,
      view_options = { show_hidden = true },
    },
    {
      "echasnovski/mini.files",
      version = false,
      keys = {
        {
          "<leader>pv",
          function()
            require("mini.files").open()
          end,
          desc = "Open file manager",
        },
      },
      opts = {
        mappings = {
          synchronize = "s",
          go_in = "<Right>",
          go_out = "<Left>",
          go_in_plus = "",
          go_out_plus = "",
        },
      },
    },
  },
}
