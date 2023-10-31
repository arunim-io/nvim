local M = {}

function M.setup_snippet_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  ---@diagnostic disable-next-line: inject-field
  capabilities.textDocument.completion.completionItem.snippetSupport = true

  return capabilities
end

return M
