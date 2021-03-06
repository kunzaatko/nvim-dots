-- setting explicitly makes startup faster
vim.g.loaded_python_provider = 0
vim.g.python3_host_prog = '/usr/bin/python3'

-- Disable some built-in plugins
local disabled_built_ins = {
    'gzip', 'man', 'matchit', 'matchparen', 'shada_plugin', 'tarPlugin', 'tar',
    'zipPlugin', 'zip', 'netrwPlugin'
}
for _, plugin in ipairs(disabled_built_ins) do vim.g['loaded_' .. plugin] = 1 end

--  config  --
require 'conf'

--  Mappings  --
require 'map'

--  Colours  --
require 'colours'

