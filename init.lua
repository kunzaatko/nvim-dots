-- setting explicitly makes startup faster
vim.g.loaded_python_provider = 0
vim.g.python3_host_prog = '/usr/bin/python3'

--  Options  --
require 'options'

--  Mappings  --
require 'map'

--  Colours  --
require 'colours'

--  AutoCommands  --
require 'autocmds'
