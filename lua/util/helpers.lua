local M = {}

---@brief Safely call a function that requires a plugin
---@param plugin string name of the plugin required by the function
---@param f function function to call
---@param ... [any] arguments to the function
function M.require_plugin(plugin, f, ...)
  local plugin_exists, _ = pcall(require, plugin)
  if not plugin_exists then
    local msg = string.format('Plugin "%s" is not loaded', plugin)
    vim.notify_once(msg, vim.log.levels.ERROR, { name = 'Plugin', icon = static.icons.link })
    return false
  else
    return f(...)
  end
end

return M
