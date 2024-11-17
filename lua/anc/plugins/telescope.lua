--- @type LazySpec
return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = require("nixCatsUtils").lazyAdd("make"),
      cond = require("nixCatsUtils").lazyAdd(function()
        return vim.fn.executable("make") == 1
      end),
    },
  },
  event = "VimEnter",
  init = function()
    pcall(require("telescope").load_extension, "fzf")
  end,
  config = true,
  keys = {
    { "<leader>pfr", "<cmd>Telescope find_files<cr>", desc = "[F]ind files in [R]oot directory." },
    { "<leader>pfg", "<cmd>Telescope git_files<cr>", desc = "[F]ind files in [G]it directory." },
    {
      "<leader>pfo",
      function()
        require("telescope.builtin").oldfiles({ cwd = vim.fn.expand("%:p:h") })
      end,
      desc = "[F]ind recently [O]pened files.",
    },
    {
      "<leader>pfa",
      function()
        require("telescope.builtin").find_files({ prompt_title = "Find adjacent files", cwd = vim.fn.expand("%:p:h") })
      end,
      desc = "[F]ind files in the directory [A]djacent to current buffer.",
    },
    {
      "<leader>ps",
      function()
        require("telescope.builtin").grep_string({ search = vim.fn.input("Grep > ") })
      end,
      desc = "[S]earch in current directory",
    },
    {
      "<leader>bl",
      function()
        require("telescope.builtin").buffers({ only_cwd = true, sort_lastused = true })
      end,
      desc = "[L]ist [B]uffers",
    },
    { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "[S]earch in current [B]uffer" },
  },
}
