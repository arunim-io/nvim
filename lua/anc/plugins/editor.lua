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
      options = { use_as_default_explorer = true },
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
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    config = true,
    keys = {
      { "<leader>dl", "<cmd>lua vim.diagnostic.open_float()<cr>", desc = "Show [D]iagnostics for current line" },
      { "<leader>dw", "<cmd>Trouble diagnostics toggle<cr>", desc = "Show [D]iagnostics for current [W]orkspace" },
      {
        "<leader>dd",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Show [D]iagnostics for current buffer",
      },
    },
  },
  {
    "echasnovski/mini.pairs",
    version = false,
    event = "VeryLazy",
    opts = {
      modes = { insert = true, command = true, terminal = false },
      -- skip autopair when next character is one of these
      skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
      -- skip autopair when the cursor is inside these treesitter nodes
      skip_ts = { "string" },
      -- skip autopair when next character is closing pair
      -- and there are more closing pairs than opening pairs
      skip_unbalanced = true,
      -- better deal with markdown code blocks
      markdown = true,
    },
  },
  { "folke/ts-comments.nvim", event = "VeryLazy", config = true },
  { "echasnovski/mini.ai", version = false, event = "VeryLazy", config = true },
  {
    "MagicDuck/grug-far.nvim",
    opts = { headerMaxWidth = 80 },
    cmd = "GrugFar",
    keys = {
      {
        "<leader>sr",
        function()
          local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")

          require("grug-far").open({
            transient = true,
            prefills = {
              filesFilter = ext and ext ~= "" and "*." .. ext or nil,
            },
          })
        end,
        mode = { "n", "v" },
        desc = "Search and Replace",
      },
    },
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = { "BufEnter" },
    config = true,
    keys = {
      {
        "]t",
        function()
          require("todo-comments").jump_next()
        end,
        desc = "Next Todo Comment",
      },
      {
        "[t",
        function()
          require("todo-comments").jump_prev()
        end,
        desc = "Previous Todo Comment",
      },
    },
  },
  {
    "echasnovski/mini.comment",
    version = false,
    event = "VeryLazy",
    opts = {
      options = {
        custom_commentstring = function()
          return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
        end,
      },
    },
  },
  { "echasnovski/mini.surround", version = false, config = true },
}
