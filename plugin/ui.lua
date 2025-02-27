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

MiniDeps.add("EdenEast/nightfox.nvim")

require("nightfox").setup({
  options = {
    transparent = true,
  },
})

vim.cmd.colorscheme("carbonfox")
