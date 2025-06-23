local snippets = require("mini.snippets")

snippets.setup({
  snippets = {
    snippets.gen_loader.from_lang(),
  },
  mappings = {
    stop = "<Esc>",
  },
  expand = {
    match = function(snips)
      return snippets.default_match(snips, { pattern_fuzzy = "%S+" })
    end,
  },
})

vim.api.nvim_create_autocmd("User", {
  desc = "Stop session immediately after jumping to final tabstop",
  pattern = "MiniSnippetsSessionJump",
  callback = function(args)
    if args.data.tabstop_to == "0" then
      MiniSnippets.session.stop()
    end
  end,
})

vim.api.nvim_create_autocmd("User", {
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
