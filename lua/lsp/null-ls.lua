local null_ls = require "null-ls"
local builtins = null_ls.builtins

null_ls.setup {
  sources = {
    builtins.code_actions.statix,
    builtins.code_actions.shellcheck,
    -- builtins.diagnostics.djlint,
    builtins.diagnostics.dotenv_linter,
    builtins.diagnostics.editorconfig_checker,
    builtins.diagnostics.fish,
    builtins.diagnostics.shellcheck,
    builtins.formatting.black,
    -- builtins.formatting.djlint,
    builtins.formatting.fish_indent,
    builtins.formatting.nixpkgs_fmt,
    builtins.formatting.prettierd,
    builtins.formatting.shfmt,
    require "typescript.extensions.null-ls.code-actions",
  },
}
