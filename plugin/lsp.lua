local add = MiniDeps.add

add("neovim/nvim-lspconfig")

local servers = {}

servers.lua_ls = {
  settings = {
    Lua = {
      workspace = { checkThirdParty = false },
      codeLens = { enable = true },
      completion = { callSnippet = "Replace" },
      doc = { privateName = { "^_" } },
    },
  },
}

for name, config in pairs(servers) do
  config.capabilities=require('blink.cmp').get_lsp_capabilities(config.capabilities, true)

  require("lspconfig")[name].setup(config)
end

add("folke/lazydev.nvim")

require("lazydev").setup({
  library = {
    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    _G.Config.mini_path,
  },
})
