--- @class LintOpts
--- @field events string[]
--- @field linters_by_ft table<string, string[]>
--- @field linters table<string, fun():lint.Linter|lint.Linter>?

--- @type LazySpec
return {
  "mfussenegger/nvim-lint",
  event = "BufEnter",
  --- @param opts LintOpts
  config = function(_, opts)
    local lint = require("lint")

    lint.linters_by_ft = opts.linters_by_ft

    if opts.linters then
      for linter, config in ipairs(opts.linters) do
        lint.linters[linter] = config
      end
    end

    vim.api.nvim_create_autocmd(opts.events, {
      callback = function()
        lint.try_lint()
      end,
    })
  end,
  --- @type LintOpts
  opts = {
    events = { "BufWritePost", "BufReadPost", "InsertLeave" },
    linters_by_ft = {
      lua = { "selene" },
      djangohtml = { "djlint" },
      htmldjango = { "djlint" },
    },
  },
  keys = {
    {
      "<leader>l",
      function()
        require("lint").try_lint()
      end,
      desc = "[L]int current buffer",
    },
  },
}
