return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = function() require("nvim-treesitter.install").update({ with_sync = true })() end,
    config = function(_, opts) require('nvim-treesitter.configs').setup(opts) end,
    dependencies = 'JoosepAlviste/nvim-ts-context-commentstring',
    event = 'BufReadPre',
    opts = {
      sync_install = true,
      highlight = { enable = true },
      indent = { enable = true },
      context_commentstring = { enable = true },
      ensure_installed = {
        "bash",
        "css",
        "dockerfile",
        "fish",
        "html",
        "htmldjango",
        "javascript",
        "jsdoc",
        "json",
        "jsonc",
        "lua",
        "nix",
        "python",
        "regex",
        "rust",
        "scss",
        "ssh_config",
        "svelte",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "yaml"
      },
    },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = 'BufRead',
    opts = {
      indent = { char = '▏' },
    }
  },
  { 'numToStr/Comment.nvim', config = true, event = 'BufRead' },
  {
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    event = 'BufRead',
    config = true,
    opts = {
      snippet_engine = "luasnip",
    },
    keys = {
      {
        "<leader>gds",
        function() require('neogen').generate() end,
        desc = 'Generate docstring',
        noremap = true,
        silent = true
      },
    },
  },
  {
    "folke/todo-comments.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    config = true,
    event = 'BufRead',
  },
}
