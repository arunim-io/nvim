--[[ General ]]
vim.o.undofile = true

vim.o.backup = false
vim.o.writebackup = false

vim.o.mouse = "a"
vim.o.mousescroll = "ver:25,hor:6"

vim.cmd("filetype plugin indent on")

vim.o.switchbuf = "usetab"
vim.o.shada = "'100,<50,s10,:1000,/100,@100,h"
vim.o.swapfile = false

--[[ GUI ]]
vim.o.guifont = "JetBrainsMonoNL NF:h13:#e-subpixelantialias"
vim.g.neovide_opacity = 0.5
vim.g.neovide_normal_opacity = 0.75
vim.g.neovide_hide_mouse_when_typing = true
vim.g.neovide_cursor_animation_length = 0

--[[ UI ]]
vim.o.breakindent = true
vim.o.cursorline = true
vim.o.linebreak = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.splitbelow = true
vim.o.splitright = true

vim.o.ruler = false
vim.o.showmode = false
vim.o.wrap = true

vim.o.signcolumn = "yes"
vim.o.colorcolumn = "+1"
vim.o.fillchars = table.concat({
  "eob: ",
  "fold:╌",
  "horiz:═",
  "horizdown:╦",
  "horizup:╩",
  "vert:║",
  "verthoriz:╬",
  "vertleft:╣",
  "vertright:╠",
}, ",")

vim.o.pumblend = 10
vim.o.pumheight = 10
vim.o.winblend = 10

vim.o.listchars = table.concat({ "extends:…", "nbsp:␣", "precedes:…", "tab:> " }, ",")
vim.o.list = true

vim.o.shortmess = "CFOSWaco"
vim.o.splitkeep = "screen"

vim.o.cursorlineopt = "screenline,number"
vim.o.breakindentopt = "list:-1"

vim.o.title = true
vim.o.titlestring = '%t%( %M%)%( (%{expand("%:~:h")})%)%a (nvim)'

-- [[ Colours ]]
if vim.fn.exists("syntax_on") ~= 1 then
  vim.cmd("syntax enable")
end

-- [[ Editing ]]
vim.o.ignorecase = true
vim.o.incsearch = true
vim.o.infercase = true
vim.o.smartcase = true
vim.o.smartindent = true
vim.o.autoindent = true
vim.o.expandtab = true
vim.o.formatoptions = "rqnl1j"
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.expandtab = true
vim.o.virtualedit = "block"

vim.o.iskeyword = "@,48-57,_,192-255,-"
vim.o.formatlistpat = [[^\s*[0-9\-\+\*]\+[\.\)]*\s\+]]
vim.o.inccommand = "split"

-- [[ Spelling ]]
vim.o.spelllang = "en,uk"
vim.o.spelloptions = "camel"

--TODO: custom dictionary
--vim.o.dictionary = vim.fn.stdpath('config') .. '/misc/dict/english.txt'

-- [[ Folds ]]
vim.o.foldmethod = "indent"
vim.o.foldlevel = 1
vim.o.foldnestmax = 10
vim.g.markdown_folding = 1
vim.o.foldtext = ""

-- [[ Custom autocommands ]]
local augroup = vim.api.nvim_create_augroup("CustomSettings", {})
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  --[[ Don't auto-wrap comments and don't insert comment leader after hitting 'o'.
    If don't do this on `FileType`, this keeps reappearing due to being set in filetype plugins.
    --]]
  command = "setlocal formatoptions-=c formatoptions-=o",
  desc = "Ensure proper 'formatoptions'",
})

--[[ Diagnostics ]]
vim.diagnostic.config({
  float = { border = "double" },
  signs = {
    priority = 9999,
    severity = {
      min = vim.diagnostic.severity.WARN,
      max = vim.diagnostic.severity.ERROR,
    },
  },
  virtual_text = {
    severity = {
      min = vim.diagnostic.severity.WARN,
      max = vim.diagnostic.severity.ERROR,
    },
  },
})

--[[ Clipboard ]]
if vim.fn.has("wsl") then
  vim.g.clipboard = {
    name = "WslClipboard",
    copy = {
      ["+"] = "clip.exe",
      ["*"] = "clip.exe",
    },
    paste = {
      ["+"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      ["*"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    },
    cache_enabled = 0,
  }
end
