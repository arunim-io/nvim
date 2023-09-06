return {
  -- Tmux support
  {
    "aserowy/tmux.nvim",
    enabled = vim.env.TMUX ~= nil,
    lazy = false,
    opts = {
      navigation = { enable_default_keybindings = false },
      resize = { enable_default_keybindings = false },
    },
    keys = function()
      return {
        { '<C-A-Left>',  function() require('tmux').move_left() end,   desc = 'Move to left pane' },
        { '<C-A-Down>',  function() require('tmux').move_bottom() end, desc = 'Move to bottom pane' },
        { '<C-A-Up>',    function() require('tmux').move_top() end,    desc = 'Move to top pane' },
        { '<C-A-Right>', function() require('tmux').move_right() end,  desc = 'Move to right pane' },
      }
    end,
  },
  -- Colour highlighting
  { 'brenoprata10/nvim-highlight-colors', opts = { enable_tailwind = true } },
}
