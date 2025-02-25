vim.cmd([[
  colorscheme default

  highlight Normal  guibg=none
  highlight NonText guibg=none
  highlight Normal  ctermbg=none
  highlight NonText ctermbg=none
]])

require("mini.hipatterns").setup()

local mini_icons = require("mini.icons")

mini_icons.setup()

package.preload["nvim-web-devicons"] = function()
  mini_icons.mock_nvim_web_devicons()
  return package.loaded["nvim-web-devicons"]
end

require("mini.indentscope").setup()
require("mini.notify").setup()
require("mini.starter").setup()
require("mini.statusline").setup()
require("mini.trailspace").setup()
