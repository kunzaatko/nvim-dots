require 'config.options'
require 'config.keymaps'
require 'config.autocommands'
require 'config.diagnostics'
require 'config.lsp'

---@brief Pretty print table with all its shallow items
---@param it table|string
function _G.pprint(it)
  print(vim.inspect(it))
end
