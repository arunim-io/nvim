local lualine = require("lualine")

local config = lualine.get_config() or {}

if pcall(require, "auto-session") then
  table.insert(config.sections.lualine_c, 1, require("auto-session.lib").current_session_name)
end

if pcall(require, "trouble") then
  local trouble = require("trouble")
  local symbols = trouble.statusline({
    mode = "lsp_document_symbols",
    groups = {},
    title = false,
    filter = { range = true },
    format = "{kind_icon}{symbol.name:Normal}",
    hl_group = "lualine_c_normal",
  })
  table.insert(config.sections.lualine_c, {
    symbols.get,
    cond = symbols.has,
  })
end

lualine.setup(config)
