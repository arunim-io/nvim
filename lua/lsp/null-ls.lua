local null_ls = require "null-ls"
local builtins = null_ls.builtins

null_ls.setup {
  sources = {
    builtins.code_actions.statix,
    builtins.diagnostics.djlint,
    builtins.diagnostics.dotenv_linter,
    builtins.diagnostics.editorconfig_checker,
    builtins.formatting.black,
    builtins.formatting.djlint,
    builtins.formatting.nixpkgs_fmt,
    builtins.formatting.prettierd,
  }
}
