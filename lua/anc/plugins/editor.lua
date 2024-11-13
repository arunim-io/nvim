--- @return LazySpec
return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = true,
    init = function()
      vim.opt.timeoutlen = 300
    end,
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
  {
    "echasnovski/mini.files",
    lazy = false,
    version = false,
    opts = {
      mappings = {
        synchronize = "s",
        go_in = "<Right>",
        go_out = "<Left>",
        go_in_plus = "",
        go_out_plus = "",
      },
    },
    keys = {
      {
        "<leader>pvr",
        function()
          MiniFiles.open(nil, false)
        end,
        desc = "[V]iew files in root directory",
      },
      {
        "<leader>pvc",
        function()
          MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
        end,
        desc = "[V]iew files in root directory",
      },
    },
  },
}
