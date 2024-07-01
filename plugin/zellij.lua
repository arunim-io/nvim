---@class SubCommand
---@field impl fun(args: string[], opts: table)
---@field complete? fun(subcmd_arg_lead: string): string[]

---@enum FocusDirectionMap
local focus_direction_map = {
  left = "h",
  down = "j",
  up = "k",
  right = "l",
}

--- Move focus to another neovim buffer or zellij pane
---@param direction 'left'|'right'|'up'|'down'
local function move_focus(direction)
  -- get window ID, try switching windows, and get ID again to see if it worked
  local cur_winnr = vim.fn.winnr()
  vim.api.nvim_command("wincmd " .. focus_direction_map[direction])
  local new_winnr = vim.fn.winnr()

  -- if the window ID didn't change, then we didn't switch
  if cur_winnr == new_winnr then
    vim.fn.system("zellij action move-focus " .. direction)
    if vim.v.shell_error ~= 0 then
      vim.notify("zellij.nvim: `zellij` executable not found in PATH", vim.log.levels.ERROR)
    end
  end
end

---@type table<string, SubCommand>
local subcommands = {
  navigate = {
    impl = function(args)
      local direction = args[1]

      if not direction then
        vim.notify("Zellij navigate {direction}: Missing argument", vim.log.levels.ERROR)
      end

      move_focus(direction)
    end,
    complete = function(subcmd_arg_lead)
      local args = { "left", "right", "up", "down" }

      return vim
        .iter(args)
        :filter(function(arg)
          return arg:find(subcmd_arg_lead) ~= nil
        end)
        :totable()
    end,
  },
}

---@param opts table
local function cmd(opts)
  local fargs = opts.fargs
  local subcommand_key = fargs[1]
  local args = #fargs > 1 and vim.list_slice(fargs, 2, #fargs) or {}
  local subcommand = subcommands[subcommand_key]

  if not subcommand then
    vim.notify("zellij.nvim: Unknown command: " .. subcommand_key, vim.log.levels.ERROR)
  end

  subcommand.impl(args, opts)
end

vim.api.nvim_create_user_command("Zellij", cmd, {
  nargs = "+",
  bang = true,
  complete = function(arg_lead, cmdline, _)
    local subcmd_key, subcmd_arg_lead = cmdline:match("^['<,'>]*Zellij[!]*%s(%S+)%s(.*)$")

    if subcmd_key and subcmd_arg_lead and subcommands[subcmd_key] and subcommands[subcmd_key].complete then
      return subcommands[subcmd_key].complete(subcmd_arg_lead)
    end

    if cmdline:match("^['<,'>]*Zellij[!]*%s+%w*$") then
      local subcommand_keys = vim.tbl_keys(subcommands)

      return vim
        .iter(subcommand_keys)
        :filter(function(key)
          return key:find(arg_lead) ~= nil
        end)
        :totable()
    end
  end,
})

vim.keymap.set("n", "<A-Left>", function()
  move_focus("left")
end)
vim.keymap.set("n", "<A-Right>", function()
  move_focus("right")
end)
vim.keymap.set("n", "<A-Up>", function()
  move_focus("up")
end)
vim.keymap.set("n", "<A-Down>", function()
  move_focus("down")
end)
