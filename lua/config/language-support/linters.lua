local lint = require("lint")

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	callback = function()
		lint.try_lint()
	end,
})

vim.keymap.set("n", "<leader>l", lint.try_lint, { desc = "Run [L]inters" })

lint.linters_by_ft = {}

local function lint_progress()
	local linters = lint.get_running()
	if #linters == 0 then
		return "󰦕"
	end
	return "󱉶 " .. table.concat(linters, ", ")
end

-- TODO: Custom ui for listing configured linter like `ConformInfo`
