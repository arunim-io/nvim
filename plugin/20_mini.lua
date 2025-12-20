local now, later, now_if_args = MiniDeps.now, MiniDeps.later, Config.now_if_args

--[[ colorschemes ]]
now(function() vim.cmd.colorscheme("minispring") end)

--[[ Setup `mini.basics` for common configuration presets ]]
now(
	function()
		require("mini.basics").setup({
			options = { basic = false },
			mappings = {
				window = true,
				move_with_alt = true,
			},
		})
	end
)

--[[ Setup `mini.icons` for providing icons. ]]
now(function()
	require("mini.icons").setup({
		--- @param ext string
		use_file_extension = function(ext, _)
			local ext3_blocklist, ext4_blocklist = { scm = true, txt = true, yml = true }, { json = true, yaml = true }

			return not (ext3_blocklist[ext:sub(-3)] or ext4_blocklist[ext:sub(-4)])
		end,
	})

	later(MiniIcons.mock_nvim_web_devicons)
	later(MiniIcons.tweak_lsp_kind)
end)

--[[ Setup `mini.misc` for some small but useful functions. ]]
now_if_args(function()
	require("mini.misc").setup()

	MiniMisc.setup_auto_root()
	MiniMisc.setup_restore_cursor()
	MiniMisc.setup_termbg_sync()
end)

--[[ Setup `mini.notify` for managing notifications ]]
now(function() require("mini.notify").setup() end)

--[[ Setup `mini.starter` for start screen ]]
now(function() require("mini.starter").setup() end)

--[[ Setup `mini.extra` for extra functionality ]]
later(function() require("mini.extra").setup() end)

--[[ Setup `mini.ai` for handling a/i textobjects ]]
later(function()
	local ai = require("mini.ai")

	ai.setup({
		custom_textobjects = {
			B = MiniExtra.gen_ai_spec.buffer(),
			F = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
		},
		search_method = "cover",
	})
end)

--[[ Setup `mini.bracketed` for moving with square brackets ]]
later(function() require("mini.bracketed").setup() end)

--[[ Setup `mini.bufremove` for removing buffers with ease ]]
later(function() require("mini.bufremove").setup() end)

--[[ Setup `mini.clue` for showing next key clues in a floating window ]]
later(function()
	local clue = require("mini.clue")

	clue.setup({
		clues = {
			Config.leader_group_clues,
			clue.gen_clues.builtin_completion(),
			clue.gen_clues.g(),
			clue.gen_clues.marks(),
			clue.gen_clues.registers(),
			clue.gen_clues.windows({ submode_resize = true }),
			clue.gen_clues.z(),
		},
		triggers = {
			{ mode = "n", keys = "<Leader>" }, -- Leader triggers
			{ mode = "x", keys = "<Leader>" },
			{ mode = "n", keys = "\\" }, -- mini.basics
			{ mode = "n", keys = "[" }, -- mini.bracketed
			{ mode = "n", keys = "]" },
			{ mode = "x", keys = "[" },
			{ mode = "x", keys = "]" },
			{ mode = "i", keys = "<C-x>" }, -- Built-in completion
			{ mode = "n", keys = "g" }, -- `g` key
			{ mode = "x", keys = "g" },
			{ mode = "n", keys = "'" }, -- Marks
			{ mode = "n", keys = "`" },
			{ mode = "x", keys = "'" },
			{ mode = "x", keys = "`" },
			{ mode = "n", keys = '"' }, -- Registers
			{ mode = "x", keys = '"' },
			{ mode = "i", keys = "<C-r>" },
			{ mode = "c", keys = "<C-r>" },
			{ mode = "n", keys = "<C-w>" }, -- Window commands
			{ mode = "n", keys = "z" }, -- `z` key
			{ mode = "x", keys = "z" },
		},
	})
end)

--[[ Setup `mini.comment` for commenting code ]]
later(function() require("mini.comment").setup() end)

--[[ Setup `mini.completion` for code completion & signature help ]]
later(function()
	require("mini.completion").setup({
		lsp_completion = {
			source_func = "omnifunc",
			auto_setup = false,
			process_items = function(items, base)
				return MiniCompletion.default_process_items(items, base, {
					kind_priority = { Text = -1, Snippet = 99 },
				})
			end,
		},
	})

	Config.new_autocmd("LspAttach", {
		desc = "Set 'omnifunc' for code completion",
		callback = function(args) vim.bo[args.buf].omnifunc = "v:lua.MiniCompletion.completefunc_lsp" end,
	})

	vim.lsp.config("*", { capabilities = MiniCompletion.get_lsp_capabilities() })
end)

--[[ Setup `mini.diff` for working with diffs ]]
later(function() require("mini.diff").setup() end)

--[[ Setup `mini.files` for managing the filesystem ]]
later(function()
	require("mini.files").setup({
		options = { use_as_default_explorer = true },
		mappings = {
			synchronize = "s",
			go_in = "<Right>",
			go_out = "<Left>",
			go_in_plus = "",
			go_out_plus = "",
		},
		windows = { preview = true },
	})

	Config.new_autocmd("User", {
		pattern = "MiniFilesExplorerOpen",
		desc = "Add bookmarks",
		callback = function() MiniFiles.set_bookmark("w", vim.fn.getcwd, { desc = "Working directory" }) end,
	})
end)

--[[ Setup `mini.git` for Git integration ]]
later(function() require("mini.git").setup() end)

--[[ Setup `mini.hipatterns` for highlight patterns in text, like `TODO`/`NOTE` or color hex codes. ]]
later(function()
	local hipatterns = require("mini.hipatterns")
	local hi_words = MiniExtra.gen_highlighter.words

	hipatterns.setup({
		highlighters = {
			hex_color = hipatterns.gen_highlighter.hex_color(),
			fixme = hi_words({ "FIXME", "Fixme", "fixme" }, "MiniHipatternsFixme"),
			hack = hi_words({ "HACK", "Hack", "hack" }, "MiniHipatternsHack"),
			todo = hi_words({ "TODO", "Todo", "todo" }, "MiniHipatternsTodo"),
			note = hi_words({ "NOTE", "Note", "note" }, "MiniHipatternsNote"),
		},
	})
end)

--[[ Setup `mini.indentscope` for handling indent scopes ]]
later(function() require("mini.indentscope").setup() end)

--[[ Setup `mini.keymap` for speacial key mappings ]]
later(function()
	require("mini.keymap").setup()

	MiniKeymap.map_multistep("i", "<Tab>", { "pmenu_next" })
	MiniKeymap.map_multistep("i", "<S-Tab>", { "pmenu_prev" })
	MiniKeymap.map_multistep("i", "<CR>", { "pmenu_accept", "minipairs_cr" })
	MiniKeymap.map_multistep("i", "<BS>", { "minipairs_bs" })
end)

--[[ Setup `mini.operators` for text edit operators ]]
later(function()
	require("mini.operators").setup()

	vim.keymap.set("n", "(", "gxiagxila", { remap = true, desc = "Swap arg left" })
	vim.keymap.set("n", ")", "gxiagxina", { remap = true, desc = "Swap arg right" })
end)

--[[ Setup `mini.pairs` for autopairs functionality ]]
later(function() require("mini.pairs").setup({ modes = { command = true } }) end)

--[[ Setup `mini.pick` for pickers ]]
later(function() require("mini.pick").setup() end)

--[[ Setup `mini.snippets` for handling snippets ]]
later(function()
	local snippets = require("mini.snippets")
	local latex_patterns = { "latex/**/*.json", "**/latex.json" }

	snippets.setup({
		expand = {
			match = function(snips) return snippets.default_match(snips, { pattern_fuzzy = "%S+" }) end,
		},
		mappings = { stop = "<ESC>" },
		snippets = {
			snippets.gen_loader.from_file(vim.fn.stdpath("config") .. "/snippets/global.json"),
			snippets.gen_loader.from_lang({
				lang_patterns = {
					markdown_inline = { "markdown.json" },
					tex = latex_patterns,
					plaintex = latex_patterns,
				},
			}),
		},
	})

	MiniSnippets.start_lsp_server()

	Config.new_autocmd("User", {
		desc = "Stop session immediately after jumping to final tabstop",
		pattern = "MiniSnippetsSessionJump",
		callback = function(args)
			if args.data.tabstop_to == "0" then MiniSnippets.session.stop() end
		end,
	})

	Config.new_autocmd("User", {
		desc = "Stop all sessions on Normal mode exit",
		pattern = "MiniSnippetsSessionStart",
		callback = function()
			vim.api.nvim_create_autocmd("ModeChanged", {
				pattern = "*:n",
				once = true,
				callback = function()
					while MiniSnippets.session.get() do
						MiniSnippets.session.stop()
					end
				end,
			})
		end,
	})
end)

--[[ Setup `mini.splitjoin` for argument splitting/joining ]]
later(function() require("mini.splitjoin").setup() end)

--[[ Setup `mini.surround` for surround actions ]]
later(function() require("mini.surround").setup() end)

--[[ Setup `mini.trailspace` for handling trailspaces ]]
later(function() require("mini.trailspace").setup() end)

--[[ Setup `mini.visits` to handle filesystem visits ]]
later(function() require("mini.visits").setup() end)
