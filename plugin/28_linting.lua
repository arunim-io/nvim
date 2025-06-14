MiniDeps.add("mfussenegger/nvim-lint")

local lint = require("lint")

lint.linters_by_ft = {
  lua = { "selene" },
  fish = { "fish" },
}

--- @generic T : function
--- Run the given function after the specified interval.
--- @param interval integer
--- @param callback T
--- @return function?
local function debounce(interval, callback)
  local timer = vim.uv.new_timer()

  if not timer then
    return
  end

  return function(...)
    local args = { ... }

    timer:start(interval, 0, function()
      timer:stop()
      vim.schedule_wrap(callback)(unpack(args))
    end)
  end
end

local function try_lint()
  local names = lint._resolve_linter_by_ft(vim.bo.filetype)

  names = vim.list_extend({}, names)

  if #names == 0 then
    vim.list_extend(names, lint.linters_by_ft["_"] or {})
  end
  vim.list_extend(names, lint.linters_by_ft["*"] or {})

  if #names > 0 then
    lint.try_lint(names)
  end
end

vim.keymap.set("n", "<leader>fl", try_lint, { desc = "Run linters" })

vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, { callback = debounce(100, try_lint) })
