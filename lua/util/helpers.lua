local M = {}

--- Notify the user that a plugin is not loaded.
---@param name string The name of the plugin.
---@param opts table? Optional table of options to pass to `vim.notify_once`.
function M.notify_plugin_not_loaded(name, opts)
  opts = vim.tbl_extend('force', { name = 'Plugin', icon = static.icons.link }, (opts or {}))
  local msg = string.format('Plugin "%s" is not loaded', name)
  vim.notify_once(msg, vim.log.levels.ERROR, opts)
end

return M
