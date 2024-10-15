require("nixCatsUtils").setup({ non_nix_value = true })

require("config")

local flake_lib = require("nix-tools.lib")

local input_paths = flake_lib:get_input_paths()

vim.print(input_paths)
