local cmd = vim.cmd

-- NOTE: Compiles the plugins into byte stings to make startup faster <kunzaatko> --
local impatient_ok, impatient = pcall(require, 'impatient')
if impatient_ok then
  impatient.enable_profile()
end

-- setting explicitly makes start-up faster
vim.g.loaded_python_provider = 0
vim.g.python3_host_prog = '/usr/bin/python3'

-- Disable built-in plug-ins
local disabled_built_ins = {
  '2html_plugin', -- disable 2html
  'getscript', -- disable getscript
  'getscriptPlugin', -- disable getscript
  'gzip', -- disable gzip
  'logipat', -- disable logipat
  'matchit', -- disable matchit
  'netrwFileHandlers', -- disable netrw
  'netrwPlugin', -- disable netrw
  'netrwSettngs', -- disable netrw
  'remote_plugins', -- disable remote plugins
  'tar', -- disable tar
  'tarPlugin', -- disable tar
  'zip', -- disable zip
  'zipPlugin', -- disable zip
  'vimball', -- disable vimball
  'vimballPlugin', -- disable vimball
}
for _, plugin in ipairs(disabled_built_ins) do
  vim.g['loaded_' .. plugin] = 1
end

for _, source in ipairs {
  'core.conf',
  'core.map',
  'core.utils',
} do
  local status_ok, _ = pcall(require, source)
  -- TODO: When all is moved uncomment <kunzaatko>
  --[[ if not status_ok then
    vim.api.nvim_err_writeln('Failed to load ' .. source .. '\n\n' .. fault)
  end ]]
end

--  config  --
require 'conf'

--  Mappings  --
require 'map'

-- Utils --
require 'utils'

cmd [[
  command! Sync lua require('pkg.utils').packer_install()
]]
