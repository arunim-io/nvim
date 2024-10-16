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
---@param cmd string[] command args to be passed to the `nix` command
---@return string? out the output of the command
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
--- @return table? metadata the output parsed from the json
function lib:fetch_metadata()
  local json = self:run_cli_cmd({ "flake", "metadata", "--json" })

  if json then
    return vim.json.decode(json)
  end
end

--- Get a table of metadata of inputs from the flake metadata.
---@return table? inputs a table of inputs parsed from the flake metadata
function lib:get_input_metadata()
  local metadata = self:fetch_metadata()

  if not metadata then
    return
  end

  local nodes = metadata.locks.nodes

  -- Remove non-flake inputs as they aren't needed.
  for key, data in pairs(nodes) do
    if data.flake ~= nil then
      nodes[key] = nil
    end
  end

  -- `nix flake metadata` command also returns the inputs of the inputs specified in `flake.nix`, so they need to be removed.
  local main_inputs = {}

  for _, input in ipairs(vim.tbl_keys(nodes.root.inputs)) do
    main_inputs[input] = true
  end

  -- Here, if the input name doesn't match, it will be removed.
  for node in pairs(nodes) do
    if not main_inputs[node] then
      nodes[node] = nil
    end
  end

  -- Finally, remove the root node as it isn't needed in the return value.
  nodes.root = nil

  return nodes
end

function lib:get_flake_ref(node)
  local locked = node.locked

  local ref = ("%s:%s/%s/%s"):format(locked.type, locked.owner, locked.repo, locked.rev)

  if node.original.dir then
    ref = ("%s?dir=%s"):format(ref, node.original.dir)
  end

  return ref
end

--- Get the nix store paths of inputs.
---@return table?
function lib:get_input_store_paths()
  local inputs = self:get_input_metadata()

  if not inputs then
    return
  end

  local paths = {}

  for input, node in pairs(inputs) do
    local expr = ([[ builtins.getFlake "%s" ]]):format(self:get_flake_ref(node))

    local result = self:run_cli_cmd({ "eval", "--impure", "--json", "--expr", expr })

    if result then
      paths[input] = vim.trim(result):gsub('"', "")
    end
  end

  return paths
end

--- Get a table of inputs where each input contains its metadata & its store path.
--- @return table? inputs a table of inputs.
function lib:get_inputs()
  local input_metadata, store_paths = self:get_input_metadata(), self:get_input_store_paths()

  if not input_metadata or not store_paths then
    return
  end

  local inputs = {}

  for input, metadata in pairs(input_metadata) do
    inputs[input] = {}
    inputs[input].metadata = metadata
  end

  for input, path in pairs(store_paths) do
    inputs[input].path = path
  end

  return inputs
end

return lib
