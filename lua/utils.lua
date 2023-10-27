--- Check which linux distro neovim is running on
--- @param distro_name string
--- @return boolean
local function check_distro(distro_name)
  local out = vim.fn.system { 'uname', '--all' }
  if out ~= nil then
    local exists = string.find(out, distro_name)
    if exists ~= nil then
      return true
    else
      return false
    end
  else
    return false
  end
end


--- Is neovim running on NixOS?
local isNixOS = check_distro('NixOS')

return { isNixOS = isNixOS }
