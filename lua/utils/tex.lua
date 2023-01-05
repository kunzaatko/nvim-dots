local M = {}

local Job = require 'plenary.job'
local path = require 'plenary.path'
local scan = require 'plenary.scandir'

M.COMPILERS = {
  tectonic = {
    build = function()
      local buildjob = Job:new {
        command = 'tectonic',
        args = { '-X', 'build' },
        cwd = M.tex.get_root():absolute(),
        -- TODO: on_stderror <kunzaatko>
      }
      vim.notify 'Building(tectonic): started'
      buildjob:start()
      buildjob:after(function()
        vim.notify 'Building(tectonic): finished'
      end)
      return buildjob
    end,

    watch = function()
      local watchjob = Job:new {
        command = 'tectonic',
        args = { '-X', 'watch' },
        cwd = M.tex.get_root():absolute(),
        -- TODO: on_stderror <kunzaatko>
      }
      vim.notify 'Watch(tectonic): started'
      watchjob:start()
      return watchjob
    end,

    -- TODO: Opts should not make a differece here <30-09-22>
    output = function(file, opts)
      return scan.scan_dir(
        M.tex.get_root(file, opts):joinpath('build'):absolute(),
        { search_pattern = { '.*%.pdf', depth = 2 } }
      )
    end,
  },
}

M.openpdf = function(viewer, output)
  local viewjob
  if #output > 1 then
    -- TODO: Handle this situation <30-09-22, kunzaatko>
    viewjob = Job:new {
      command = viewer,
      args = output,
      cwd = M.tex.get_root():absolute(),
    }
  else
    viewjob = Job:new {
      command = viewer,
      args = output,
      cwd = M.tex.get_root():absolute(),
    }
  end
  vim.notify('Opening: ' .. path:new(output[1]):shorten())
  viewjob:start()
  return viewjob
end

M.tex = {
  -- TODO: Implement fully <kunzaatko>
  --- Get the root of the TeX document for the given file
  ---@param file string
  ---@param opts table
  --- opts.tectonic bool - tectonic structure
  --- opts.mainfile_patterns table[string] - regexes for index.tex file (['[Ii]ndex.tex',
  --'[Mm]ain.tex'])
  --- opts.mainfile_height int - number of directories the mainfile is above the root
  --- opts.git_repo bool - root is git repo
  --- opts.includes_dirs table[string] - regexes that the root directory includes
  --- opts.max_depth int - maximum search depth
  get_root = function(file, opts)
    file = file or vim.fn.expand '%'

    opts = opts or {}
    opts = vim.tbl_extend('keep', opts, { mainfile = { '[Ii]ndex.tex', '[Mm]ain.tex' } })

    local filepath = path:new(file)
    -- TODO: Add tests for filepath <kunzaatko>

    local search_dir = filepath:is_dir() and filepath or filepath:parent()
    while vim.tbl_isempty(scan.scan_dir(search_dir:absolute(), { search_pattern = { 'src$', 'Tectonic.toml' } })) do
      search_dir = search_dir:parent()
    end

    return search_dir
  end,

  external = {
    compile = function(type)
      if M.COMPILERS[type] then
        M.COMPILERS[type].compile()
      else
        error 'Not known compiler type'
      end
    end,

    watch = function(type)
      if M.COMPILERS[type] then
        M.COMPILERS[type].compile()
      else
        error 'Not known compiler type'
      end
    end,
  },
}

--- Get the PID of running `inkscape_figures watch` daemon
---@return number|nil
M.get_watch_daemon_pid = function()
  -- {{{
  -- NOTE: This relies on the shell being bash <kunzaatko> --
  -- PERF: This blocks nvim input --
  -- TODO: Should be done by spawning a process instead to enable nonblocking <12-11-21, kunzaatko> --
  local handle =
    io.popen [[ps --no-headers -C "$(xlsclients | cut -d' ' -f3 | paste - -s -d ',')" --ppid 2 --pid 2 --deselect -o tty,pid,args | rg -e "^\\?.*inkscape-figures watch" | awk '{print $2}']]
  local pid = handle:read '*a'
  return pid and tonumber(pid) or nil
end -- }}}

--- PID of the figure watch daemon
-- M.watch_daemon_pid = M.get_watch_daemon_pid()

--- Checks whether the process with given PID is running
---@param pid number
---@return boolean running
M.process_running = function(pid)
  return io.popen('ps --no-headers -p ' .. tostring(pid)) and true or false
end

--- Ensure that the watch daemon is running by checking if it exists and starting it if doesn't
--- @return boolean started_by_this_call
M.ensure_watch_daemon = function()
  -- {{{
  -- PERF: closure because we want to run only when needed
  local start_daemon = function()
    Job:new({ command = 'inkscape-figures', args = { 'watch', '--daemon' }, cwd = vim.b.vimtex.root }):start()
    M.watch_daemon_pid = M.get_watch_daemon_pid()
    return true
  end

  if M.watch_daemon_pid then
    if M.process_running(M.watch_daemon_pid) then
      return false
    else
      start_daemon()
    end
  else
    start_daemon()
  end
  return true
end -- }}}

--- Send a sigterm signal to the watch daemon
M.kill_watch_daemon = function()
  -- {{{
  Job:new({ command = 'kill', args = { '-15', tostring(M.get_watch_daemon_pid()) } }):start()
end -- }}}

--- Get the tex root of the current buffer
---@return table root (plenary path)
M.get_tex_root = function()
  return path.new(vim.b.vimtex.root)
end

-- TODO: Some REGEX for adding label and caption at the same time for ex. (some fig (This fig shows a function), or: some fig: this fig shows a function [a sin function in the functions section]) <07-11-21, kunzaatko> "

--- Run `inkscape-figures create` with the right tex root
---@param fig_name string
M.inkscape_figures_create = function(fig_name)
  -- {{{
  -- M.ensure_watch_daemon()
  local figs_root = M.tex.get_root():joinpath 'figures'
  local inkfig_create = Job:new {
    command = 'inkscape-figures',
    args = { 'create', fig_name },
    cwd = figs_root:absolute(),
  }

  local inkfig_template = inkfig_create:sync()

  -- vim.api.nvim_paste(table.concat(inkfig_template, '\n'), false, 1)
  vim.api.nvim_put(inkfig_template, 'l', false, true)

  -- table.insert(LaTeX_template, '') -- Add a blank line to the end

  -- vim.notify(vim.inspect(LaTeX_template))

  -- vim.api.nvim_put(LaTeX_template, 'l', false, true)
end -- }}}

--- Run `inkscape-figures edit` with the right tex root
M.inkscape_figures_edit = function()
  -- {{{
  -- M.ensure_watch_daemon()
  local figs_root = M.tex.get_root():joinpath 'figures'
  Job:new({ command = 'inkscape-figures', args = { 'edit', figs_root:absolute() } }):start()
end -- }}}

M.inkscape_figures_watch = function()
  local watchjob = Job:new {
    command = 'inkscape-figures',
    args = { 'watch', '--daemon' },
    cwd = M.tex.get_root():joinpath('figures'):absolute(),
  }

  vim.notify 'Inkscape(watch-daemon): started'
  watchjob:start()
  -- FIX: Does not work <30-09-22>
  vim.api.nvim_create_autocmd('VimLeavePre', {
    group = vim.api.nvim_create_augroup('Inkscape(watch-daemon)_' .. watchjob.pid, {}),
    callback = function()
      watchjob:shutdown()
    end,
  })
  return watchjob
end

M.inkscape_shortcut_manager = function()
  local pipenvjob = Job:new {
    command = 'pipenv',
    args = { 'shell' },
    cwd = '/home/kunzaatko/.local/lib/inkscape-shortcut-manager',
  }

  local managerjob = Job:new {
    command = 'python',
    args = { 'main.py' },
    cwd = '/home/kunzaatko/.local/lib/inkscape-shortcut-manager',
  }

  vim.notify 'Inkscape(shortcuts): started'
  pipenvjob:after_success(managerjob)
  pipenvjob:start()
  return managerjob
end

return M
