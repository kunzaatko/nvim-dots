local M = {}

local _, term = pcall(require, 'snacks.terminal')

---@brief Default snacks.terminal.Opts options for the REPL
M.DEFAULT_REPL_OPTS = {
  shell = 'fish',
  -- NOTE: `auto_insert` is very annoying, when debugging and error that is diagnosed in the REPL and being fixed in
  -- another buffer. If you return to the REPL window, the window jumps down from the error to the prompt to start
  -- "insert". Note that there is also a distinct option `start_insert` which is `true` by default. <19-05-25>
  auto_insert = false,
  win = {
    position = 'right',
    keys = {
      win_right = {
        '<M-h>',
        function()
          vim.cmd 'wincmd h'
        end,
        mode = { 'n', 't' },
        desc = 'Window: navigate right',
      },
      win_down = {
        '<M-j>',
        function()
          vim.cmd 'wincmd j'
        end,
        mode = { 't', 'n' },
        desc = 'Window: navigate down',
      },
      win_up = {
        '<M-k>',
        function()
          vim.cmd 'wincmd k'
        end,
        mode = { 't', 'n' },
        desc = 'Window: navigate up',
      },
      win_left = {
        '<M-l>',
        function()
          vim.cmd 'wincmd l'
        end,
        mode = { 't', 'n' },
        desc = 'Window: navigate left',
      },
      toggle_normal = {
        '<C-n>',
        function()
          vim.cmd 'stopinsert'
        end,
        mode = { 't' },
        desc = 'Normal mode',
      },
    },
  },
}

---@brief Launch a oneshot terminal
---@param cmd string
---@param opts snacks.terminal.Opts
function M.oneshot(cmd, opts)
  return require('util.helpers').require_plugin('snacks', function()
    opts = opts or {}
    return term.open(cmd, vim.tbl_extend('keep', opts, { shell = 'fish' }))
  end)
end

-- TODO: To the REPL add an icon of the REPL language. This should be done by the bufferline option of the Snacks win
-- Opts <26-04-25>

---@brief Setup a keymap for launching a REPL
---@param cmd string Command for launching the repl
---@param toggle_key string Key to toggle the terminal (usually the same as the key that this function is bound to)
---@param opts snacks.terminal.Opts|nil Options passed to the snacks terminal window. Keep in mind that if the options
---define a list, then it is not merged with the defaults but is a replacement to the defaults. This is significant in
---the `win.keys` option, where if you want to keep the defined keymaps, you need to name the additional keys instead of
---passing a list.
---@return snacks.win|boolean terminal? Returns false is snacks is not loaded, otherwise returns the terminal window
---toggled
function M.toggle_repl(cmd, toggle_key, opts)
  return require('util.helpers').require_plugin('snacks', function()
    opts = opts or {}
    local repl_opts = vim.tbl_deep_extend('force', M.DEFAULT_REPL_OPTS, {
      win = {
        keys = {
          toggle = {
            toggle_key,
            function()
              term.toggle(cmd, opts)
            end,
            mode = { 'n', 't' },
            desc = 'Toggle REPL',
          },
        },
      },
    })
    return term.toggle(cmd, vim.tbl_deep_extend('keep', opts, repl_opts))
  end)
end

-- TODO: Send text function with option of <enter> at the end <18-05-23>

return M
