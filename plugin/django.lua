--- Check if the current directory contains a django project by either checking for the `DJANGO_SETTINGS_MODULE` env variable or searching for django's `manage.py` file.
---@return boolean|nil
local function check_django_install()
  if vim.fn.getenv("DJANGO_SETTINGS_MODULE") ~= nil then
    return true
  end

  local cwd = vim.fn.getcwd()
  local manage_script = vim.uv.fs_stat(vim.fs.joinpath(cwd, "manage.py"))

  return manage_script and manage_script.type == "file"
end

vim.api.nvim_create_autocmd("FileType", {
  desc = "Make sure that the filetype of django templates is set correctly",
  pattern = "html",
  callback = function(args)
    if vim.bo[args.buf].filetype ~= "htmldjango" then
      if check_django_install() then
        vim.bo[args.buf].filetype = "htmldjango"
      end
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  desc = "Enable django snippets",
  pattern = { "htmldjango", "python" },
  callback = function()
    if check_django_install() then
      local luasnip = require("luasnip")

      luasnip.filetype_extend("htmldjango", "djangohtml")
      luasnip.filetype_extend("python", "django")
    end
  end,
})
