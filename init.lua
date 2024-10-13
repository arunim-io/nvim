require("nixCatsUtils").setup({ non_nix_value = true })

require("config")

local function get_flake_metadata()
  local cwd = vim.fn.getcwd()

  if vim.fn.filereadable(cwd .. "/flake.nix") ~= 1 then
    return
  end

  local system = vim.system({ "nix", "flake", "metadata", "--json" }, { cwd = cwd, text = true })

  return vim.fn.json_decode(system:wait().stdout)
end

local function get_flake_inputs()
  local flake_metadata = get_flake_metadata()

  if not flake_metadata then
    return
  end

  local nodes = flake_metadata.locks.nodes

  -- Remove non-flake inputs
  for key, data in pairs(nodes) do
    if data.flake ~= nil then
      nodes[key] = nil
    end
  end

  nodes.root = nil

  return nodes
end

local metadata = get_flake_metadata()
local flake_inputs = get_flake_inputs()

if not metadata or not flake_inputs then
  return
end

for key, value in pairs(flake_inputs) do
end

local ref = metadata.locks.nodes.systems.locked

vim.print(
  vim.fn.system(
    string.format(
      [[nix eval --impure --json --expr 'builtins.getFlake "%s:%s/%s/%s"']],
      ref.type,
      ref.owner,
      ref.repo,
      ref.rev
    )
  )
)
