local Job = require "plenary.job"
local path = require "plenary.path"
_G.MUtils = MUtils or {}
_G.TEXUtils = TEXUtils or {}

--- Get the PID of running `inkscape_figures watch` daemon
---@return number|nil
TEXUtils.get_watch_daemon_pid = function()
  -- {{{
  -- NOTE: This relies on the shell being bash <kunzaatko> --
  -- PERF: This blocks nvim input --
  -- TODO: Should be done by spawning a process instead to enable nonblocking <12-11-21, kunzaatko> --
  local handle = io.popen(
                   [[ps --no-headers -C "$(xlsclients | cut -d' ' -f3 | paste - -s -d ',')" --ppid 2 --pid 2 --deselect -o tty,pid,args | rg -e "^\\?.*inkscape-figures watch" | awk '{print $2}']]
                 )
  local pid = handle:read("*a")
  return pid and tonumber(pid) or nil
end -- }}}

--- PID of the figure watch daemon
TEXUtils.watch_daemon_pid = TEXUtils.get_watch_daemon_pid()

--- Checks whether the process with given PID is running
---@param pid number
---@return boolean running
TEXUtils.process_running = function( pid )
  return io.popen("ps --no-headers -p " .. tostring(pid)) and true or false
end

--- Ensure that the watch daemon is running by checking if it exists and starting it if doesn't
--- @return boolean started_by_this_call
TEXUtils.ensure_watch_daemon = function()
  -- {{{
  -- PERF: closure because we want to run only when needed
  local start_daemon = function()
    Job:new(
      { command = 'inkscape-figures', args = { "watch" }, cwd = vim.b.vimtex.root }
    ):start()
    TEXUtils.watch_daemon_pid = TEXUtils.get_watch_daemon_pid()
    return true
  end

  if TEXUtils.watch_daemon_pid then
    if TEXUtils.process_running(TEXUtils.watch_daemon_pid) then
      return false
    else
      start_daemon()
    end
  else
    start_daemon()
  end
end -- }}}

--- Send a sigterm signal to the watch daemon
TEXUtils.kill_watch_daemon = function()
  -- {{{
  Job:new(
    { command = 'kill', args = { '-15', tostring(TEXUtils.get_watch_daemon_pid()) } }
  ):start()
end -- }}}

--- Get the tex root of the current buffer
---@return table root (plenary path)
TEXUtils.get_tex_root = function()
  return path.new(vim.b.vimtex.root)
end

-- TODO: Some REGEX for adding label and caption at the same time for ex. (some fig (This fig shows a function), or: some fig: this fig shows a function [a sin fucntion in the functions section]) <07-11-21, kunzaatko> "

--- Run `inkscape-figures create` with the right tex root
---@param fig_name string
MUtils.inkscape_figures_create = function( fig_name )
  -- {{{
  TEXUtils.ensure_watch_daemon()
  local figs_root = path.new(vim.b.vimtex.root):joinpath("figures")
  local LaTeX_template = Job:new(
                           {
      command = 'inkscape-figures',
      args = { 'create', fig_name, figs_root.filename },
    }
                         ):sync()
  table.insert(LaTeX_template, "") -- Add a blank line to the end

  vim.api.nvim_put(LaTeX_template, "l", false, true)
  vim.api.nvim_del_current_line()
  vim.cmd 'write'
end -- }}}

--- Run `inkscape-figures edit` with the right tex root
MUtils.inkscape_figures_edit = function()
  -- {{{
  TEXUtils.ensure_watch_daemon()
  local figs_root = path.new(vim.b.vimtex.root):joinpath("figures")
  Job:new({ command = 'inkscape-figures', args = { 'edit', figs_root.filename } })
    :start()
end -- }}}

return TEXUtils
