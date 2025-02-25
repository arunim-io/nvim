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
  require("lspconfig")[name].setup(config)
end

add("folke/lazydev.nvim")

require("lazydev").setup({
  library = {
    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    _G.Config.mini_path,
  },
})
