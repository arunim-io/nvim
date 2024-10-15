--- @class NixFlake
--- Table containing details of a [`nix flake`](https://nix.dev/manual/nix/2.18/command-ref/new-cli/nix3-flake#description).
local lib = {}

local function get_cwd()
  local cwd, err, err_msg = vim.uv.cwd()

  if err ~= nil then
    vim.notify(err, vim.log.levels.ERROR)
    return
  end
  if err_msg ~= nil then
    vim.notify(err_msg, vim.log.levels.ERROR)
    return
  end

  if cwd == nil then
    return vim.fn.getcwd()
  end

  return cwd
end

--- Check if `flake.nix` is present in the given directory `dir`.
--- If `dir` is not given, the current directory will be used.
--- @param dir string? the target directory. Defaults to the current directory.
--- @return boolean? `true` if `flake.nix` is found else `false`
function lib:check_if_exists(dir)
  local cwd = dir or get_cwd()

  if cwd then
    return vim.fn.filereadable(cwd .. "/flake.nix") == 1
  end
end

--- Run `nix` command in a different process
---@param cmd string[] command args to pass to the `nix` command
---@return string?
function lib:run_cli_cmd(cmd)
  table.insert(cmd, 1, "nix")

  local result = vim.system(cmd, { cwd = get_cwd(), text = true }):wait()

  if result.code ~= 0 then
    vim.notify(result.stderr, vim.log.levels.ERROR)
    return
  end

  return result.stdout
end

--- Fetch metadata of current flake and set it to [`flake.metadata`](lua://NixFlake.metadata) field.
--- @return table?
function lib:fetch_metadata()
  local json = self:run_cli_cmd({ "flake", "metadata", "--json" })

  if json then
    return vim.json.decode(json)
  end
end

--- Get a list of inputs from the flake metadata.
---@return table?
function lib:get_inputs()
  local metadata = self:fetch_metadata()

  if metadata then
    local nodes = metadata.locks.nodes

    -- Remove non-flake inputs
    for key, data in pairs(nodes) do
      if data.flake ~= nil then
        nodes[key] = nil
      end
    end

    nodes.root = nil

    return nodes
  end
end

--- Get the nix store paths of inputs.
---@return table?
function lib:get_input_paths()
  local inputs = self:get_inputs()

  if inputs then
    local paths = {}

    for input, node in pairs(inputs) do
      local ref = node.locked

      local expr = ([[ builtins.getFlake "%s:%s/%s/%s" ]]):format(ref.type, ref.owner, ref.repo, ref.rev)

      paths[input] = self:run_cli_cmd({ "eval", "--impure", "--json", "--expr", expr })
    end

    return paths
  end
end

return lib
