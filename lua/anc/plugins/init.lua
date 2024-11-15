return {
  {
    "folke/snacks.nvim",
    name = "snacks-nvim",
    priority = 1000,
    lazy = false,
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesActionRename",
        callback = function(event)
          Snacks.rename.on_rename_file(event.data.from, event.data.to)
        end,
      })
    end,
    --- @type snacks.Config
    opts = {
      bigfile = { enabled = true },
      quickfile = { enabled = true },
      words = { enabled = true },
    },
    keys = {
      {
        "<leader>gg",
        function()
          Snacks.lazygit()
        end,
        desc = "Open Lazygit",
      },
      {
        "<leader>gl",
        function()
          Snacks.lazygit.log()
        end,
        desc = "View git log using Lazygit",
      },
      {
        "<leader>gL",
        function()
          Snacks.lazygit.log_file()
        end,
        desc = "View git log for current file using Lazygit",
      },
      {
        "]]",
        function()
          Snacks.words.jump(vim.v.count1)
        end,
        desc = "Jump to next reference",
        mode = { "n", "t" },
      },
      {
        "[[",
        function()
          Snacks.words.jump(-vim.v.count1)
        end,
        desc = "Jump to prev reference",
        mode = { "n", "t" },
      },
      {
        "<leader>bdd",
        function()
          Snacks.bufdelete()
        end,
        desc = "[D]elete current [B]uffer",
      },
      {
        "<leader>bda",
        function()
          Snacks.bufdelete.all()
        end,
        desc = "[D]elete [A]ll [B]uffers",
      },
      {
        "<leader>bdd",
        function()
          Snacks.bufdelete.other()
        end,
        desc = "[D]elete all [O]ther [B]uffers except the current one",
      },
      {
        "<leader>rf",
        function()
          Snacks.rename.rename_file()
        end,
        desc = "[R]ename current [F]ile",
      },
    },
  },
}
