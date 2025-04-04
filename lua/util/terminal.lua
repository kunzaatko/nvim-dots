local M = {}

local terminal_exists, term = pcall(require, 'terminal')
local utils = require 'util.helpers'

---@table globally stored terminals
_G.terminals = {}

if terminal_exists then
  --- Launch a oneshot terminal
  ---@param opts table: passed to the terminal (see `terminal:new` from 'rebelot/terminal.nvim')
  function M.oneshot(opts)
    term.terminal:new(opts):open()
  end

  --- Launch a terminal that is unique to the given key.
  --- (Can be useful for project terminals unique to the project root)
  ---@param key function|string: function to generate the key based on the context or string
  ---@param term_opts table: passed to the terminal (see `terminal:new` from 'rebelot/terminal.nvim')
  ---@param opts table
  --- autostart boolean: whether to start the terminal automatically
  --- location unknown: where the terminal is stored (default: `_G.terminals`)
  ---@return unknown: terminal handle
  function M.unique(key, term_opts, opts, ...)
    opts.location = opts.location or _G.terminals
    local term_key = type(key) == 'function' and key(...) or key

    if not opts.location[term_key] then
      opts.location[term_key] = term.terminal:new(term_opts)
      if opts.autostart then
        -- TODO:  <18-05-23>
      end
    end

    return opts.location[term_key]
  end
else
  function M.oneshot(...)
    utils.notify_plugin_not_loaded 'terminal'
  end
  function M.unique(...)
    utils.notify_plugin_not_loaded 'terminal'
  end
end

-- TODO: Send text function with option of <enter> at the end <18-05-23>

return M
