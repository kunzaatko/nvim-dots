-- FIX: Highlighting of the Function Parameters should be in a dimmer colour than the parameters in the function <11-06-25>
-- FIX: Using julia 1.12 because julia 1.11.5 causing 139 error where it apparently accesses an invalid address. When
-- 1.12 is the release, should remove the version specifier in order not to run with the overhead of fish <25-04-25>
-- TODO: Add a keymap to generate the documentation for a package <11-06-25>
-- TODO: Add autopairs `endwise` rules for "begin end" groups and for "do end"
-- https://github.com/windwp/nvim-autopairs/wiki/Endwise#list-rule-predefined-by-user <11-05-23>
-- TODO: Add a special notification title and icon for notifications that are linked to julia. See `h snacks-notifier` <20-06-25>
-- TODO: Terminal send keymap with motion support <16-04-25>

local term = require 'util.terminal'

local JULIA_PROJECT_REPL_CMD = 'fish -c "julia +1.12 --project --threads auto"'
local JULIA_REPL_CMD = 'fish -c "julia +1.12"'

--- Format the lines before sending them to the REPL
---@param text string: The input text
---@return string: The modified text
local function send_format(text)
  local lines = {}
  for line in text:gmatch '([^\n]*)\n?' do
    if line ~= '' then
      -- Remove 'julia>\s*' from the lines
      local filtered = line:gsub('^julia>', '')
      table.insert(lines, filtered)
    end
  end
  return table.concat(lines, '\n') .. (text:sub(-1) == '\n' and '\n' or '')
end

--- Toggle the REPL for the current project
local function julia_project_repl()
  term.toggle_repl(JULIA_PROJECT_REPL_CMD, '¶', {
    win = {
      wo = {
        winbar = '%=Julia - Project REPL%=',
      },
    },
  }, '¶', send_format)
end

vim.api.nvim_buf_create_user_command(0, 'JuliaREPL', julia_project_repl, { nargs = '?' })

-- NOTE: <RightAlt + r>
vim.keymap.set('n', '¶', julia_project_repl, { desc = 'Julia REPL for project', buffer = true })

vim.keymap.set('n', 'g¶', function()
  term.toggle_repl(JULIA_PROJECT_REPL_CMD, '¶', {
    env = {
      ['JULIA_DOCUMENTING'] = true,
    },
    win = {
      wo = {
        winbar = '%=Julia - documentation REPL%=',
      },
    },
  }, 'g¶', send_format)
end, { desc = 'Julia project REPL for documentation', buffer = true })

-- NOTE: <LocalLeader><RightAlt + r>
vim.keymap.set('n', '<LocalLeader>¶', function()
  term.toggle_repl(
    JULIA_REPL_CMD,
    '<localleader>¶',
    { win = { wo = { winbar = '%=Julia - REPL%=' } } },
    '<localleader>¶',
    send_format
  )
end, { desc = 'Julia REPL toggle', buffer = true })

vim.keymap.set('n', '<LocalLeader>t', function()
  term.oneshot(
    'fish -c "julia +1.12 --project --eval \'using Pkg; Pkg.test()\'"',
    { auto_close = false, win = { position = 'right', wo = { winbar = '%=Julia - Tests%=' } } }
  )
end, { desc = 'Run PACKAGE tests', buffer = true })

vim.keymap.set('n', '<LocalLeader>D', function()
  term.oneshot('fish -c "julia --project --color=yes make.jl"', {
    cwd = './docs/',
    auto_close = false,
    win = { position = 'right', wo = { winbar = '%=Julia - Build Documentation%=' } },
  })
end, { desc = 'Run PACKAGE tests', buffer = true })

vim.keymap.set('n', '<LocalLeader>T', function()
  term.oneshot('fish -c "julia +1.12 --project --eval \'using Pkg; Pkg.test()\'"', {
    env = { ['RUNTESTS_FULL'] = true },
    auto_close = false,
    win = { position = 'right', wo = { winbar = '%=Julia - Tests (RUNTESTS_FULL)%=' } },
  })
end, { desc = 'Run ALL tests (RUNTESTS_FULL=1)', buffer = true })

vim.keymap.set('n', '<LocalLeader>gT', function()
  term.oneshot('fish -c "julia +1.12 --project --eval \'using Pkg; Pkg.test()\'"', {
    env = { ['RUNTESTS_FULL'] = true, ['FIX_DOCTESTS'] = true },
    auto_close = false,
    win = { position = 'right', wo = { winbar = '%=Julia - Tests (RUNTESTS_FULL, FIX_DOCTESTS)%=' } },
  })
end, { desc = 'Run ALL tests and fix doctests (RUNTESTS_FULL=1, FIX_DOCTESTS=1)', buffer = true })

-- TODO: persistent `JULIA_TEST_ARGS_LAST` <09-08-25>
---@brief Last test arguments used
_G.JULIA_TEST_ARGS_LAST = nil
-- TODO: Add completion via the `:command-completion` "custom,func" option. We have to have the test folder for this <14-07-25>
vim.keymap.set('n', '<LocalLeader>gt', function()
  local path = vim.api.nvim_buf_get_name(0)
  local testname = string.match(path, 'test/(.*).jl')
  testname = testname and testname ~= 'runtests' and string.format('"%s"', testname)
  vim.ui.input({
    prompt = 'Fill `test_args`',
    default = testname or _G.JULIA_TEST_ARGS_LAST,
  }, function(input)
    input = input or ''

    local test_args = string.len(input) == 0 and '' or string.format('test_args=[%q]', input)

    if string.len(test_args) ~= 0 then
      vim.notify('Testing with `test_args`: `' .. string.format('[%s]', input) .. '`')
    end

    _G.JULIA_TEST_ARGS_LAST = input or testname and string.format('"%s"', testname)

    local command = 'fish -c "julia +1.12 --project --eval \'using Pkg; Pkg.test(' .. test_args .. ')\'"'

    local run_tests_function
    local rerun_keys = {
      win = {
        keys = {
          rerun = {
            'R',
            function()
              vim.schedule(run_tests_function)
            end,
            mode = { 'n', 't' },
            desc = 'Rerun tests',
          },
        },
      },
    }

    local opts = vim.tbl_deep_extend('keep', {
      auto_close = false,
      win = {
        position = 'right',
        wo = { winbar = ('%=Julia - Tests `test_args=' .. string.format('[%s]', input) .. '`%=') },
      },
    }, rerun_keys)

    run_tests_function = function()
      term.oneshot(command, opts)
    end
    run_tests_function()
  end)
end, { desc = 'Run tests selected tests', buffer = true })
