require("config.options")
require("config.keymaps")
require("config.language-support")
require("config.ui")
require("config.helpers")

if nixCats('telescope') then
  require("config.telescope")
end
