local M = {}
local visual = require 'util.visual'

---@brief Default keymaps for terminal navigation
---@type snacks.win.Keys
M.TERMINAL_NAV_KEYS = {
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
}

---@brief Default snacks.terminal.Opts options for the REPL
---@type snacks.terminal.Opts
M.DEFAULT_REPL_OPTS = {
  shell = 'fish',
  -- NOTE: `auto_insert` is very annoying, when debugging and error that is diagnosed in the REPL and being fixed in
  -- another buffer. If you return to the REPL window, the window jumps down from the error to the prompt to start
  -- "insert". Note that there is also a distinct option `start_insert` which is `true` by default. <19-05-25>
  auto_insert = false,
  win = {
    position = 'right',
    keys = vim.tbl_extend('keep', {
      toggle_normal = {
        '<C-n>',
        function()
          vim.cmd 'stopinsert'
        end,
        mode = { 't' },
        desc = 'Normal mode',
      },
    }, M.TERMINAL_NAV_KEYS),
  },
}
-- TODO: Add a key mapping that reruns the command in the window. This should take the `win` and launch a new terminal
-- in that place with the command. <09-08-25>
-- TODO: On a `oneshot` with the same command, should replace the existing `oneshot` window and rerun the command <09-08-25>
---@brief Default snacks.terminal.Opts options for the oneshot terminal
M.DEFAULT_ONESHOT_OPTS = {
  shell = 'fish',
  start_insert = true,
  auto_insert = false,
  win = {
    enter = false,
    keys = M.TERMINAL_NAV_KEYS,
    on_win = function(win)
      vim.schedule(function()
        vim.api.nvim_win_call(win.win, function()
          vim.cmd [[normal! G]]
        end)
      end)
    end,
  },
}

---@brief Launch a oneshot terminal
---@param cmd string
---@param opts snacks.terminal.Opts
---@return snacks.win
function M.oneshot(cmd, opts)
  return require('util.helpers').require_plugin('snacks', function()
    local term = require 'snacks.terminal'
    opts = opts or {}
    local win, created = term.get(cmd, vim.tbl_deep_extend('keep', opts, M.DEFAULT_ONESHOT_OPTS))
    if not created then
      vim.notify 'Closing existing `oneshot`'
      win:close()
      win = term.open(cmd, vim.tbl_deep_extend('keep', opts, M.DEFAULT_ONESHOT_OPTS))
    end
    return win
  end)
end

-- TODO: To the REPL add an icon of the REPL language. This should be done by the bufferline option of the Snacks win
-- Opts <26-04-25>

-- TODO: Add a filter function to filter the text sent to the REPL. For instance if blank lines should be filtered out
-- etc. <22-07-25>

---@brief Setup a keymap for launching a REPL
---@param cmd string Command for launching the REPL
---@param toggle_key string Key to toggle the terminal (usually the same as the key that this function is bound to)
---@param opts snacks.terminal.Opts|nil Options passed to the snacks terminal window. Keep in mind that if the options
---define a list, then it is not merged with the defaults but is a replacement to the defaults. This is significant in
---the `win.keys` option, where if you want to keep the defined keymaps, you need to name the additional keys instead of
---passing a list. (default `{}`)
---@param send_key string|nil Key to send to the REPL. If you want to set up a send a key for sending visual selection
---to the REPL, then pass this parameter.
---@param send_format function|nil Function to format the text before sending it to the REPL
---@return snacks.win|boolean terminal? Returns false is snacks is not loaded, otherwise returns the terminal window
---toggled
function M.toggle_repl(cmd, toggle_key, opts, send_key, send_format)
  return require('util.helpers').require_plugin('snacks', function()
    local term = require 'snacks.terminal'
    local repl_opts = M.get_repl_opts(cmd, toggle_key, opts)
    opts = opts or {}
    local repl = term.toggle(cmd, vim.tbl_deep_extend('keep', opts, repl_opts))

    local buf = vim.api.nvim_get_current_buf()
    if send_key then
      vim.keymap.set('v', send_key, function()
        vim.schedule(function()
          local vtext = table.concat(visual.get_vsel_text(), '\n') .. '\n'
          local send_text = send_format and send_format(vtext) or vtext
          vim.api.nvim_chan_send(vim.b[repl.buf].terminal_job_id, send_text)
          visual.exit_vmode()
        end)
      end, { desc = 'Send visual selection to REPL', buffer = buf })
    end
    return repl
  end)
end

---@brief Get the options for a REPL merged with the default options (used for overriding in plugins e.g.
---`opencode.nvim`)
---@param cmd string Command for launching the REPL
---@param toggle_key string Key to toggle the terminal (usually the same as the key that this function is bound to)
---@param opts snacks.terminal.Opts|nil Options passed to the snacks terminal window. Keep in mind that if the options
---define a list, then it is not merged with the defaults but is a replacement to the defaults. This is significant in
---the `win.keys` option, where if you want to keep the defined keymaps, you need to name the additional keys instead of
---passing a list. (default `{}`)
---@return snacks.terminal.Config opts? Returns false is snacks is not loaded, otherwise returns the terminal window
---toggled
function M.get_repl_opts(cmd, toggle_key, opts)
  local term = require 'snacks.terminal'
  opts = opts or {}
  return vim.tbl_deep_extend('force', M.DEFAULT_REPL_OPTS, {
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
end

-- TODO: Send text function with option of <enter> at the end <18-05-23>

return M
