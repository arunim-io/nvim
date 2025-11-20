--[[
  This plugin contains some customization related to django.
--]]

local django_filetypes = { "htmldjango", "djangohtml" }

vim.api.nvim_create_autocmd("FileType", {
  desc = "Make sure that the filetype of django templates is set correctly",
  pattern = "html",
  callback = function(args)
    local is_django = vim.fn.getenv("DJANGO_SETTINGS_MODULE") ~= vim.NIL
      or vim.fn.filereadable(vim.fs.joinpath(vim.fn.getcwd(), "manage.py")) == 1

    if not vim.list_contains(django_filetypes, vim.bo[args.buf].filetype) and is_django then
      vim.bo[args.buf].filetype = "htmldjango"
    end
  end,
})
