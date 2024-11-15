local highlight = {
  "RainbowRed",
  "RainbowYellow",
  "RainbowBlue",
  "RainbowOrange",
  "RainbowGreen",
  "RainbowViolet",
  "RainbowCyan",
}

return {
  {
    "echasnovski/mini.icons",
    event = "UIEnter",
    opts = {
      file = {
        [".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
        ["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
        [".go-version"] = { glyph = "", hl = "MiniIconsBlue" },
      },
      filetype = {
        dotenv = { glyph = "", hl = "MiniIconsYellow" },
        gotmpl = { glyph = "󰟓", hl = "MiniIconsGrey" },
      },
    },
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = "BufEnter",
    config = function()
      local hooks = require("ibl.hooks")

      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
        vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
        vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
        vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
        vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
        vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
        vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
      end)
      hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)

      require("ibl").setup({
        indent = { char = "▏" },
        scope = { highlight = highlight },
      })
    end,
  },
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = "BufEnter",
    config = function()
      vim.g.rainbow_delimiters = { highlight = highlight }
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "folke/trouble.nvim" },
    event = "VimEnter",
    config = true,
    opts = function(_, opts)
      local trouble_loaded, trouble = pcall(require, "trouble")

      if trouble_loaded then
        local symbols = trouble.statusline({
          mode = "lsp_document_symbols",
          groups = {},
          title = false,
          filter = { range = true },
          format = "{kind_icon}{symbol.name:Normal}",
          hl_group = "lualine_c_normal",
        })
        table.insert(opts.sections.lualine_c, {
          symbols.get,
          cond = symbols.has,
        })
      end

      if pcall(require, "mini.diff") then
        local x = opts.sections.lualine_x

        for _, comp in ipairs(x) do
          if comp[1] == "diff" then
            comp.source = function()
              local summary = vim.b.minidiff_summary

              return summary
                and {
                  added = summary.add,
                  modified = summary.change,
                  removed = summary.delete,
                }
            end
            break
          end
        end
      end
    end,
  },
  { "j-hui/fidget.nvim", config = true },
}
