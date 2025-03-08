require("vim.treesitter.query").add_predicate("is-mise?", function(_, _, source)
  local file_path = vim.api.nvim_buf_get_name(tonumber(source) or 0)
  local file_name = vim.fn.fnamemodify(file_path, ":t")

  return string.match(file_name, ".*mise.*%.toml$")
end, { force = true, all = false })
