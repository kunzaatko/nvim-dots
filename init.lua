local g = vim.g

-- setting explicitly makes startup faster
g.python3_host_prog = '/bin/python3'

---------------
--  Options  --
---------------
require 'options'

----------------
--  Plug-ins  --
----------------
require 'plugins'

----------------
--  Mappings  --
----------------
require 'map'

---------------
--  Colours  --
---------------
require 'colours'

--------------------
--  AutoCommands  --
--------------------
require 'autocmds'
