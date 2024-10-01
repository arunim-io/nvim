local django_manage_py_exists = false

local cwd_handler = vim.uv.fs_scandir(vim.fn.getcwd())
if cwd_handler then
  local file_name = vim.uv.fs_scandir(cwd_handler)

  if file_name and file_name == "manage.py" then
    django_manage_py_exists = true
  end
end

if django_manage_py_exists then
  vim.bo.filetype = "djangohtml"
end
