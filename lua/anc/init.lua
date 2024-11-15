require("anc.options")
require("anc.keymaps")

local nixCats = require("nixCats")
local is_nix_cats = require("nixCatsUtils").isNixCats
local nix_lazy_cats_utils = require("nixCatsUtils.lazyCat")

local plugins, lazy_path

if is_nix_cats then
  local cat_plugins = nixCats.pawsible.allPlugins

  plugins = nix_lazy_cats_utils.mergePluginTables(cat_plugins.start, cat_plugins.opt)

  plugins["blink.cmp"] = ""
  plugins["snacks.nvim"] = ""

  lazy_path = cat_plugins.start["lazy.nvim"]
end

local function get_lazy_lock_path()
  local cfg_path

  if is_nix_cats and type(cfg_path) == "string" then
    cfg_path = nixCats.settings.unwrappedCfgPath
  else
    cfg_path = vim.fn.stdpath("config")
  end

  return cfg_path .. "/lazy-lock.json"
end

local lazy_opts = {
  lockfile = get_lazy_lock_path(),
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = "⌘",
      config = "🛠",
      event = "📅",
      ft = "📂",
      init = "⚙",
      keys = "🗝",
      plugin = "🔌",
      runtime = "💻",
      require = "🌙",
      source = "📄",
      start = "🚀",
      task = "📌",
      lazy = "💤 ",
    },
  },
}

nix_lazy_cats_utils.setup(plugins, lazy_path, "anc.plugins", lazy_opts)
