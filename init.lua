require("nixCatsUtils").setup({ non_nix_value = true })

require("config")

local flake_lib = require("nix-tools.lib")

local inputs = flake_lib:get_inputs()

vim.print(inputs)
