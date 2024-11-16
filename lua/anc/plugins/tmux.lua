return {
  "aserowy/tmux.nvim",
  opts = {
    navigation = { enable_default_keybindings = false },
    resize = { enable_default_keybindings = false },
  },
  keys = {
    {
      "<C-M-Up>",
      function()
        require("tmux").resize_top()
      end,
      desc = "Resize [Up]",
    },
    {
      "<C-M-Down>",
      function()
        require("tmux").resize_bottom()
      end,
      desc = "Resize [Down]",
    },
    {
      "<C-M-Left>",
      function()
        require("tmux").resize_left()
      end,
      desc = "Resize [Left]",
    },
    {
      "<C-M-Right>",
      function()
        require("tmux").resize_right()
      end,
      desc = "Resize [Right]",
    },
    {
      "<M-Up>",
      function()
        require("tmux").move_top()
      end,
      desc = "Navigate [Up]",
    },
    {
      "<M-Down>",
      function()
        require("tmux").move_bottom()
      end,
      desc = "Navigate [Down]",
    },
    {
      "<M-Left>",
      function()
        require("tmux").move_left()
      end,
      desc = "Navigate [Left]",
    },
    {
      "<M-Right>",
      function()
        require("tmux").move_right()
      end,
      desc = "Navigate [Right]",
    },
  },
}
