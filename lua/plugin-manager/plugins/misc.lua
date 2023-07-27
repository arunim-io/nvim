return {
  {
    "aserowy/tmux.nvim",
    lazy = false,
    opts = {
      navigation = { enable_default_keybindings = false },
      resize = { enable_default_keybindings = false },
    },
    keys = function()
      return {
        { '<A-Left>',  function() require('tmux').move_left() end,   desc = 'Move to left pane' },
        { '<A-Down>',  function() require('tmux').move_bottom() end, desc = 'Move to bottom pane' },
        { '<A-Up>',    function() require('tmux').move_top() end,    desc = 'Move to top pane' },
        { '<A-Right>', function() require('tmux').move_right() end,  desc = 'Move to right pane' },
      }
    end,
  },
}
