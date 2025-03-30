vim.api.nvim_create_autocmd("FileType", {
  desc = "Make sure that the filetype of django templates is set correctly",
  pattern = "html",
  callback = function(args)
    if vim.bo[args.buf].filetype == "htmldjango" then
      return
    end

    local cwd, err = vim.uv.cwd()
    if err or not cwd then
      return
    end

    local django_manage_file = vim.uv.fs_stat(vim.fs.joinpath(cwd, "manage.py"))
    if django_manage_file and django_manage_file.type == "file" then
      vim.bo[args.buf].filetype = "htmldjango"
    end
  end,
})
