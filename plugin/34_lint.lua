MiniDeps.later(function()
	MiniDeps.add("mfussenegger/nvim-lint")

	local lint = require("lint")

	lint.linters_by_ft = {
		go = { "golangcilint" },
		lua = { "selene" },
	}

	local function try_lint()
		local linters = lint._resolve_linter_by_ft(vim.bo.filetype)

		linters = vim.list_extend({}, linters)

		if #linters == 0 then vim.list_extend(linters, lint.linters_by_ft["_"] or {}) end
		vim.list_extend(linters, lint.linters_by_ft["*"] or {})

		if #linters > 0 then require("lint").try_lint(linters) end
	end

	ANC.lint_func = try_lint

	ANC.new_autocmd("BufWritePost", { callback = function() try_lint() end })
end)
