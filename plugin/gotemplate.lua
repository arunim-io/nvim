vim.api.nvim_create_autocmd("FileType", {
  desc = "Make sure the filetype of go templates is properly set.",
  pattern = "html",
  callback = function(args)
    local is_go = vim.fn.filereadable(vim.fs.joinpath(vim.fn.getcwd(), "go.mod")) == 1
    if vim.bo[args.buf].filetype ~= "gotmpl" then
      vim.bo[args.buf].filetype = "gotmpl"
    end
  end,
})
