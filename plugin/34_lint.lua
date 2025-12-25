MiniDeps.later(function()
	MiniDeps.add("mfussenegger/nvim-lint")

	local lint = require("lint")

	lint.linters_by_ft = {
		lua = { "selene" },
	}

	Config.new_autocmd("BufWritePost", { callback = function() lint.try_lint() end })
end)
