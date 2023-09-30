return {
  {
    'Mofiqul/vscode.nvim',
    lazy = false,
    priority = 1000,
    init = function() require('vscode').load() end,
    opts = { transparent = true, italic_comments = true },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = { char = '|' },
      show_current_context_start = true,
      space_char_blankline = " ",
    }
  },
  { 'nvim-tree/nvim-web-devicons', opts = { default = true, strict = true } },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons', 'arkav/lualine-lsp-progress' },
    opts = {
      extensions = { 'lazy', 'trouble' },
      options = { theme = 'auto' },
      sections = {
        lualine_c = { 'filename', 'lsp_progress' },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
      },
    },
  },
  {
    "folke/twilight.nvim",
    config = true,
    keys = {
      { '<leader>tl', '<cmd>Twilight <cr>', desc = 'Toggle Twilight' },
    },
  },
}
