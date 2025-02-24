--[[ Map Leader ]]
vim.g.mapleader = " "

--[[ General ]]
vim.o.backup=false
vim.o.mouse='a'
vim.o.mousescroll='ver:25,hor:6'
vim.o.switchbuf='usetab'
vim.o.writebackup=false
vim.o.undofile=true

vim.o.shada= "'100,<50,s10,:1000,/100,@100,h"

vim.cmd "filetype plugin indent on"

--[[ UI ]]
vim.o.breakindent=true
vim.o.colorcolumn='+1'
vim.o.cursorline=true
vim.o.linebreak=true
vim.o.list=true
vim.o.number=true
vim.o.relativenumber=true
vim.o.pumheight=10
vim.o.ruler=false
vim.o.shortmess='CFOSWaco'
vim.o.showmode=false
vim.o.signcolumn='yes'
vim.o.splitbelow=true
vim.o.splitright=true
vim.o.wrap=true

vim.o.fillchars = table.concat(
  -- Special UI symbols
  { 'eob: ', 'fold:╌', 'horiz:═', 'horizdown:╦', 'horizup:╩', 'vert:║', 'verthoriz:╬', 'vertleft:╣', 'vertright:╠' },
  ','
)
vim.o.listchars = table.concat({ 'extends:…', 'nbsp:␣', 'precedes:…', 'tab:> ' }, ',')
vim.o.cursorlineopt='screenline,number'
vim.o.breakindentopt='list:-1'
vim.o.splitkeep='screen'

-- [[ Colours ]]
if vim.fn.exists('syntax_on') ~= 1 then
	vim.cmd 'syntax enable'
end

-- [[ Editing ]]
vim.o.autoindent=true
vim.o.expandtab=true
vim.o.formatoptions='rqnl1j'
vim.o.ignorecase=true
vim.o.incsearch=true
vim.o.infercase=true
vim.o.shiftwidth=2
vim.o.smartcase=true
vim.o.smartindent=true
vim.o.tabstop=2
vim.o.virtualedit='block'

vim.o.iskeyword='@,48-57,_,192-255,-'

vim.o.formatlistpat = [[^\s*[0-9\-\+\*]\+[\.\)]*\s\+]]

-- [[ Spelling ]]
vim.o.spelllang='en,uk'
vim.o.spelloptions='camel'

--vim.o.dictionary = vim.fn.stdpath('config') .. '/misc/dict/english.txt'

-- [[ Folds ]]
vim.o.foldmethod='indent'
vim.o.foldlevel=1
vim.o.foldnestmax=10
vim.g.markdown_folding=1
vim.o.foldtext=''

-- [[ Custom autocommands ]]
local augroup = vim.api.nvim_create_augroup('CustomSettings', {})
vim.api.nvim_create_autocmd('FileType', {
  group = augroup,
    --[[ Don't auto-wrap comments and don't insert comment leader after hitting 'o'. 
    If don't do this on `FileType`, this keeps reappearing due to being set in filetype plugins.
    --]]
  command='setlocal formatoptions-=c formatoptions-=o',
  desc = [[Ensure proper 'formatoptions']],
})

--[[ Diagnostics ]]
vim.diagnostic.config {
float={border='double'},
signs={
  priority=9999,
  severity={min='WARN',max='ERROR'},
},
virtual_text={
  severity={min='WARN',max='ERROR'},
},
-- update_in_insert=false,
}
