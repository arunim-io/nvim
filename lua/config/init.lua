require("config.options")
require("config.keymaps")
require("config.language-support")
require("config.ui")
require("config.editor")

if nixCats('telescope') then
  require("config.telescope")
end
