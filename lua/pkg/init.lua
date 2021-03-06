require 'plugins.install'

local packer = nil
local function init()
  if packer == nil then
    packer = require 'packer'
    packer.init {disable_commands = true} -- disable creating commands
  end

  local use = packer.use
  packer.reset() -- when sourcing by dofile

  use {'wbthomason/packer.nvim', opt = true} --manage packer as optional plugin

end
