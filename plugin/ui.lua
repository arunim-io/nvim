vim.cmd([[
  colorscheme default 

  highlight Normal  guibg=none
  highlight NonText guibg=none
  highlight Normal  ctermbg=none
  highlight NonText ctermbg=none
]])

require("mini.hipatterns").setup()
require("mini.icons").setup()
require("mini.indentscope").setup()
require("mini.notify").setup()
require("mini.starter").setup()
require("mini.statusline").setup()
require("mini.trailspace").setup()
