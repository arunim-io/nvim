--- This module contains the utils from [nixCats-nvim's luaUtils template](https://github.com/BirdeeHub/nixCats-nvim/blob/main/nix/templates/luaUtils), which is useful for configuring neovim.
local M = {}

-- Check if neovim is installed via nix. Useful for configuring package managers when not loaded via nix.
--- @type boolean
M.isNixCats = vim.g[ [[nixCats-special-rtp-entry-nixCats]] ] ~= nil

--- @class nixCatsSetupOpts
--- @field non_nix_value boolean?

--- defaults to true if non_nix_value is not provided or is not a boolean.
--- @param opts nixCatsSetupOpts
function M.setup(opts)
  if not M.isNixCats then
    local nixCats_default_value
    if type(opts) == "table" and type(opts.non_nix_value) == "boolean" then
      nixCats_default_value = opts.non_nix_value
    else
      nixCats_default_value = true
    end
    -- if not in nix, just make it return a boolean
    require("_G").nixCats = function(_)
      return nixCats_default_value
    end
    -- and define some stuff for the nixCats plugin
    -- to prevent indexing errors and provide some values
    package.preload["nixCats"] = function()
      return {
        cats = {},
        pawsible = {
          allPlugins = {
            start = {},
            opt = {},
            treesitter_grammars = {},
            ts_grammar_path = nil,
          },
        },
        settings = {
          nixCats_config_location = vim.fn.stdpath("config"),
          configDirName = os.getenv("NVIM_APPNAME") or "nvim",
          wrapRc = false,
        },
        configDir = vim.fn.stdpath("config"),
        packageBinPath = os.getenv("NVIM_WRAPPER_PATH_NIX") or vim.v.progpath,
      }
    end
  end
end

--- allows you to guarantee a boolean is returned, and also declare a different
--- default value than specified in setup when not using nix to load the config
--- @param v string|string[] Value to load when loaded via nix
--- @param default boolean? Default value to use when not loaded via nix
--- @return boolean
function M.enableForCategory(v, default)
  if M.isNixCats or default == nil then
    if nixCats(v) then
      return true
    else
      return false
    end
  else
    return default
  end
end

--- @generic D
--- if nix, return value of nixCats(v) else return default
--- Exists to specify a different non_nix_value than the one in setup()
--- @param v string|string[]
--- @param default D
--- @return D
function M.getCatOrDefault(v, default)
  if M.isNixCats then
    return nixCats(v)
  else
    return default
  end
end

--- @generic V, O
--- If loaded via nix, the 2nd param will be returned, otherwise return the 1st param.
--- @param v V
--- @param o O
--- @return V|O
function M.either_or(v, o)
  if M.isNixCats then
    return o
  else
    return v
  end
end

--- Useful for things such as vim-startuptime which must reference the wrapper's actual path
--- If not using nix, this will simply return vim.v.progpath
--- @type string
M.packageBinPath = os.getenv("NVIM_WRAPPER_PATH_NIX") or vim.v.progpath

return M
