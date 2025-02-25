do
  local mini_path = vim.fn.stdpath("data") .. "/site/pack/deps/start/mini.nvim"
  if not vim.uv.fs_stat(mini_path) then
    vim.cmd('echo "Installing `mini.nvim`" | redraw')
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/echasnovski/mini.nvim",
      mini_path,
    })
    vim.cmd('echo "Successfully installed `mini.nvim`" | redraw')
    vim.cmd("packadd mini.nvim | helptags ALL")
  end
end

