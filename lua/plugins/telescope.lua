return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "MaximilianLloyd/adjacent.nvim",
    "debugloop/telescope-undo.nvim",
  },
  init = function()
    local telescope = require("telescope")

    telescope.load_extension("fzf")
    telescope.load_extension("adjacent")
    telescope.load_extension("undo")
  end,
  opts = {
    pickers = {
      buffers = {
        sort_mru = true,
        mappings = {
          i = {
            ["<c-d>"] = "delete_buffer",
          },
        },
      },
    },
  },
  keys = {
    {
      "<leader>pf",
      "<cmd>Telescope find_files<cr>",
      desc = "Open root directory with Telescope",
    },
    {
      "<leader>b",
      "<cmd>Telescope buffers<cr>",
      desc = "Open buffers with Telescope",
    },
    {
      "<leader>ps",
      function()
        require("telescope.builtin").grep_string({ search = vim.fn.input("Grep > ") })
      end,
      desc = "Search with Telescope",
    },
    {
      "<leader>pa",
      "<cmd>Telescope adjacent<cr>",
      desc = "Open adjacent files with Telescope",
      noremap = true,
      silent = false,
    },
    {
      "<leader>u",
      "<cmd>Telescope undo<cr>",
      desc = "Use undotree with Telescope",
    },
  },
}
