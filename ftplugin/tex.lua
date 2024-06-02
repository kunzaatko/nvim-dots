-- NOTE: Indent blankline is very slow for LaTeX significantly lowers the performance of insertmode <18-01-24>
-- TODO: Update this to current workflow <26-03-23>
-- TODO: Add build terminal and watch terminal <12-05-23>
-- TODO: Add autopairs plugin rules for LaTeX <11-05-23>
-- TODO: Add endwise rules for begin end groups https://github.com/windwp/nvim-autopairs/wiki/Endwise#list-rule-predefined-by-user <11-05-23>
-- TODO: save the terminal numbers to enable toggling them <12-05-23>
-- TODO: when terminal exits, set autocommand to close on some keymap (once) <12-05-23>
-- TODO: Which-Key register keymaps (!!!) <20-05-23>

-- FIX: Scrolling in normal mode is very laggy <18-01-24>

---@diagnostic disable: undefined-field
local Job = require 'plenary.job'
local path = require 'plenary.path'
local scan = require 'plenary.scandir'

vim.opt.conceallevel = 2

local utils = {}

-- TODO: Compiler can be a metatable <20-05-23>
utils.COMPILERS = {
  tectonic = {
    build = function()
      local buildjob = Job:new {
        command = 'tectonic',
        args = { '-X', 'build' },
        cwd = utils.tex.get_root():absolute(),
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
        cwd = utils.tex.get_root():absolute(),
        -- TODO: on_stderror <kunzaatko>
      }
      vim.notify 'Watch(tectonic): started'
      watchjob:start()
      return watchjob
    end,

    -- TODO: Opts should not make a difference here <30-09-22>
    output = function(file, opts)
      return scan.scan_dir(
        utils.tex.get_root(file, opts):joinpath('build'):absolute(),
        { search_pattern = { '.*.pdf', depth = 1 } }
      )
    end,
  },
}

--- Open a PDF using the specified viewer
-- @param viewer string: The PDF viewer command
-- @param output table: The output file path
-- @return table: The Job object for viewing the PDF
-- @param flags table|nil: The PDF viewer flags
utils.openpdf = function(viewer, output, flags)
  local viewjob
  local flags = flags or {}
  if #output > 1 then
    -- TODO: Handle this situation <30-09-22, kunzaatko>
    viewjob = Job:new {
      command = viewer,
      args = vim.tbl_extend('force', flags, output),
      cwd = utils.tex.get_root():absolute(),
    }
  else
    viewjob = Job:new {
      command = viewer,
      args = vim.tbl_extend('force', flags, output),
      cwd = utils.tex.get_root():absolute(),
    }
  end
  vim.notify('Opening: ' .. path:new(output[1]):shorten())
  viewjob:start()
  return viewjob
end

utils.tex = {
  -- TODO: Implement fully <kunzaatko>
  --- Get the root of the TeX document for the given file
  ---@param file string|nil
  ---@param opts table|nil
  --- opts.tectonic bool - tectonic structure
  --- opts.mainfile_patterns table[string] - regexes for index.tex file (['[Ii]ndex.tex',
  --'[utils.]ain.tex'])
  --- opts.mainfile_height int - number of directories the mainfile is above the root
  --- opts.git_repo bool - root is git repo
  --- opts.includes_dirs table[string] - regexes that the root directory includes
  --- opts.max_depth int - maximum search depth
  get_root = function(file, opts)
    file = file or vim.fn.expand '%'

    opts = opts or {}
    opts = vim.tbl_extend('keep', opts, { mainfile = { '[Ii]ndex.tex', '[utils.]ain.tex' } })

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
      if utils.COMPILERS[type] then
        utils.COMPILERS[type].compile()
      else
        error 'Not known compiler type'
      end
    end,

    watch = function(type)
      if utils.COMPILERS[type] then
        utils.COMPILERS[type].compile()
      else
        error 'Not known compiler type'
      end
    end,
  },
}

--- Get the PID of running `inkscape_figures watch` daemon
---@return number|nil
utils.get_watch_daemon_pid = function()
  -- NOTE: This relies on the shell being bash <kunzaatko> --
  -- PERF: This blocks nvim input --
  -- TODO: Should be done by spawning a process instead to enable nonblocking <12-11-21, kunzaatko> --
  local handle =
    io.popen [[ps --no-headers -C "$(xlsclients | cut -d' ' -f3 | paste - -s -d ',')" --ppid 2 --pid 2 --deselect -o tty,pid,args | rg -e "^\\?.*inkscape-figures watch" | awk '{print $2}']]
  local pid = handle and handle:read '*a'
  return pid and tonumber(pid) or nil
end

--- PID of the figure watch daemon
-- utils.watch_daemon_pid = M.get_watch_daemon_pid()

--- Checks whether the process with given PID is running
---@param pid number
---@return boolean running
utils.process_running = function(pid)
  return io.popen('ps --no-headers -p ' .. tostring(pid)) and true or false
end

--- Ensure that the watch daemon is running by checking if it exists and starting it if doesn't
--- @return boolean started_by_this_call
utils.ensure_watch_daemon = function()
  -- PERF: closure because we want to run only when needed
  local start_daemon = function()
    Job:new({ command = 'inkscape-figures', args = { 'watch', '--daemon' }, cwd = vim.b.vimtex.root }):start()
    utils.watch_daemon_pid = M.get_watch_daemon_pid()
    return true
  end

  if utils.watch_daemon_pid then
    if utils.process_running(M.watch_daemon_pid) then
      return false
    else
      start_daemon()
    end
  else
    start_daemon()
  end
  return true
end

--- Send a sigterm signal to the watch daemon
utils.kill_watch_daemon = function()
  Job:new({ command = 'kill', args = { '-15', tostring(utils.get_watch_daemon_pid()) } }):start()
end

--- Get the tex root of the current buffer
---@return table root (plenary path)
utils.get_tex_root = function()
  return path.new(vim.b.vimtex.root)
end

-- TODO: Some REGEX for adding label and caption at the same time for ex. (some fig (This fig shows a function), or: some fig: this fig shows a function [a sin function in the functions section]) <07-11-21, kunzaatko> "

--- Run `inkscape-figures create` with the right tex root
---@param fig_name string
utils.inkscape_figures_create = function(fig_name)
  -- utils.ensure_watch_daemon()
  local figs_root = utils.tex.get_root():joinpath 'figures'
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
end

--- Run `inkscape-figures edit` with the right tex root
utils.inkscape_figures_edit = function()
  -- utils.ensure_watch_daemon()
  local figs_root = utils.tex.get_root():joinpath 'figures'
  Job:new({ command = 'inkscape-figures', args = { 'edit', figs_root:absolute() } }):start()
end

utils.inkscape_figures_watch = function()
  local watchjob = Job:new {
    command = 'inkscape-figures',
    args = { 'watch', '--daemon' },
    cwd = utils.tex.get_root():joinpath('figures'):absolute(),
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

utils.inkscape_shortcut_manager = function()
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

-- MAPPINGS
-- vim.keymap.set('i', '<C-f>', function()
--   local figname = vim.api.nvim_get_current_line()
--   vim.api.nvim_del_current_line()
--   utils.inkscape_figures_create(figname)
-- end, { desc = 'create an incscape figure' })
-- vim.keymap.set('n', '<C-f>', utils.inkscape_figures_edit, { desc = 'edit an incscape figure' })

vim.keymap.set(
  'n',
  '<localleader>w',
  utils.COMPILERS.tectonic.watch,
  { desc = 'watch for changes and compile on write' }
)

vim.keymap.set('n', '<localleader>b', utils.COMPILERS.tectonic.build, { desc = 'build document' })

vim.keymap.set('n', '<localleader>o', function()
  utils.openpdf('zathura', utils.COMPILERS.tectonic.output())
end, { desc = 'open output with viewer' })

-- FIX: Synctex does not work with tectonic <25-11-23>
vim.keymap.set('n', '<localleader>v', function()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  utils.openpdf(
    'zathura',
    utils.COMPILERS.tectonic.output(),
    { '--synctex-forward ' .. cursor_pos[1] .. ':' .. cursor_pos[2] .. ':' .. vim.api.nvim_buf_get_name(0) }
  )
end, { desc = 'view current position in the PDF' })

vim.keymap.set('n', '<localleader>iw', utils.inkscape_figures_watch, { desc = 'start the watch daemon' })
vim.keymap.set('n', '<localleader>is', utils.inkscape_shortcut_manager, { desc = 'start the shortcut manager' })

-- Abbreviations

local scrap = require 'scrap'
local abbreviations = scrap.expand_many({
  { 'nť', 'nechť' },
  { 'fc{e,í,i}', 'funkc{e,í,i}' },
}, { capitalized = true })

-- NOTE: This is a solution, for nvim version 9 and lower, since there was no way to set the abbreviations from lua
-- before <18-01-24>
for _, value in pairs(abbreviations) do
  vim.cmd('abbreviate ' .. value[1] .. ' ' .. value[2])
end

-- scrap.many_local_abbreviations(abbreviations)
