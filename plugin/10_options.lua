--[[ General ]]
vim.g.mapleader = " " -- Use `<Space>` as <Leader> key
vim.g.maplocalleader = " " -- Use `<Space>` as <Leader> key

vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

vim.o.mouse = "a" -- Enable mouse
vim.o.mousescroll = "ver:25,hor:60" -- Customize mouse scroll
vim.o.switchbuf = "usetab" -- treat windows like they're tabs
vim.o.undofile = true -- Make undo history persistent

vim.o.shada = "'100,<50,s10,:1000,/100,@100,h" -- Limit ShaDa file (for startup)

-- Enable all filetype plugins and syntax (if not enabled, for better startup)
vim.cmd("filetype plugin indent on")
if vim.fn.exists("syntax_on") ~= 1 then vim.cmd("syntax enable") end

--[[ UI ]]
vim.o.breakindent = true -- Indent wrapped lines to match line start
vim.o.breakindentopt = "list:-1" -- Add padding for lists (if 'wrap' is set)
vim.o.colorcolumn = "+1" -- Draw column on the right of maximum width
vim.o.conceallevel = 2 -- Hide * markup for bold & italic, but not markers with subsitutions
vim.o.cursorline = true -- Enable current line highlighting
vim.o.linebreak = true -- Wrap lines at 'breakat' (if 'wrap' is set)
vim.o.list = true -- Show helpful text indicators
vim.o.number = true -- Show line numbers
vim.o.relativenumber = true -- Show relative line numbers
vim.o.pumheight = 10 -- Make popup menu smaller
vim.o.ruler = false -- Don't show cursor coordinates
vim.o.shortmess = "CFOSWaco" -- Disable some built-in completion messages
vim.o.showmode = false -- Don't show mode in command line
vim.o.signcolumn = "yes" -- Always show signcolumn (less flicker)
vim.o.scrolloff = 4 -- Set lines of context to 4
vim.o.splitbelow = true -- Horizontal splits will be below
vim.o.splitkeep = "screen" -- Reduce scroll during window split
vim.o.splitright = true -- Vertical splits will be to the right
vim.o.winborder = "single" -- Use border in floating windows
vim.o.wrap = false -- Don't visually wrap lines (toggle with \w)

vim.o.cursorlineopt = "screenline,number" -- Show cursor line per screen line
vim.o.breakindentopt = "list:-1" -- Add padding for lists (if `wrap` is set)

-- Special UI symbols. More is set via 'mini.basics' later.
vim.o.fillchars = "eob: ,fold:╌"
vim.o.listchars = "extends:…,nbsp:␣,precedes:…,tab:> "

-- Sets the title of the process. Useful with multiplexers like tmux or zellij
vim.o.title = true
vim.o.titlestring = '%t%( %M%)%( (%{expand("%:~:h")})%)%a (nvim)'

-- Folds (see `:h fold-commands`, `:h zM`, `:h zR`, `:h zA`, `:h zj`)
vim.o.foldlevel = 10 -- Fold nothing by default; set to 0 or 1 to fold
vim.o.foldmethod = "expr" -- Fold based on indent level
vim.o.foldnestmax = 10 -- Limit number of fold levels
vim.o.foldtext = "" -- Show text under fold with its highlighting

--[[ Editing ]]
vim.o.autoindent = true -- Use auto indent
vim.o.confirm = true -- Confirm to save changes before exiting modified buffer
vim.o.expandtab = true -- Convert tabs to spaces
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()" -- use conform.nvim for formatting
vim.o.formatoptions = "rqnl1j" -- Improve comment editing
vim.o.ignorecase = true -- Ignore case during search
vim.o.incsearch = true -- Show search matches while typing
vim.o.infercase = true -- Infer case in built-in completion
vim.o.shiftround = true -- Make indents rounded
vim.o.shiftwidth = 2 -- Use this number of spaces for indentation
vim.o.smartcase = true -- Respect case if search pattern has upper case
vim.o.smartindent = true -- Make indenting smart
vim.o.spelloptions = "camel" -- Treat camelCase word parts as separate words
vim.o.tabstop = 2 -- Show tab as this number of spaces
vim.o.virtualedit = "block" -- Allow going past end of line in blockwise mode

vim.o.iskeyword = "@,48-57,_,192-255,-" -- Treat dash as `word` textobject part

-- Pattern for a start of numbered list (used in `gw`). This reads as
-- "Start of list item is: at least one special character (digit, -, +, *)
-- possibly followed by punctuation (. or `)`) followed by at least one space".
vim.o.formatlistpat = [[^\s*[0-9\-\+\*]\+[\.\)]*\s\+]]

-- Built-in completion
vim.o.complete = ".,w,b,kspell" -- Use less sources
vim.o.completeopt = "menuone,noselect,fuzzy,nosort" -- Use custom behavior

--[[ Clipboard ]]
vim.o.clipboard = vim.env.SSH_CONNECTION and "" or "unnamedplus"

--[[ Diagnostics ]]
MiniDeps.later(function()
	local ERROR, WARN, HINT = vim.diagnostic.severity.ERROR, vim.diagnostic.severity.WARN, vim.diagnostic.severity.HINT
	vim.diagnostic.config({
		-- Show signs on top of any other sign, but only for warnings and errors
		signs = {
			priority = 9999,
			severity = { min = WARN, max = ERROR },
		},
		-- Show all diagnostics as underline (for their messages type `<Leader>ld`)
		underline = {
			severity = { min = HINT, max = ERROR },
		},
		-- Show more details immediately for errors on the current line
		virtual_lines = false,
		-- Don't update diagnostics when typing
		virtual_text = {
			current_line = true,
			severity = { min = ERROR, max = ERROR },
		},
		update_in_insert = false,
	})
end)

--[[ Autocommands ]]
Config.new_autocmd("FileType", {
	desc = "Proper `formatoptions`",
	command = "setlocal formatoptions-=c formatoptions-=o",
})

Config.new_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
	desc = "Check if we need to reload the file when it changed",
	callback = function()
		if vim.o.buftype ~= "nofile" then vim.cmd.checktime() end
	end,
})

Config.new_autocmd("TextYankPost", {
	desc = "Highlight on yank",
	callback = function() vim.hl.on_yank() end,
})

Config.new_autocmd("VimResized", {
	desc = "resize splits if window got resized",
	callback = function()
		local current = vim.fn.tabpagenr()
		vim.cmd("tabdo wincmd =")
		vim.cmd("tabnext " .. current)
	end,
})

Config.new_autocmd("FileType", {
	desc = "close some filetypes with <q>",
	pattern = {
		"checkhealth",
		"dbout",
		"grug-far",
		"help",
		"mininotify-history",
		"qf",
		"startuptime",
	},
	callback = function(args)
		vim.bo[args.buf].buflisted = false

		vim.schedule(function()
			vim.keymap.set("n", "q", function()
				vim.cmd.close()
				pcall(vim.api.nvim_buf_delete, args.buf, { force = true })
			end, {
				buffer = args.buf,
				silent = true,
				desc = "Quit buffer",
			})
		end)
	end,
})

Config.new_autocmd("FileType", {
	desc = "wrap & check for spell in text filetypes",
	pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
	command = "setlocal wrap spell",
})

Config.new_autocmd("FileType", {
	desc = "Fix conceallevel for json files",
	pattern = { "json", "jsonc", "json5" },
	command = "setlocal conceallevel=0",
})
