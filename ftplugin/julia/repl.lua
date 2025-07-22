-- FIX: Highlighting of the Function Parameters should be in a dimmer colour than the parameters in the function <11-06-25>
-- FIX: Using julia 1.12 because julia 1.11.5 causing 139 error where it apparently accesses an invalid address. When
-- 1.12 is the release, should remove the version specifier in order not to run with the overhead of fish <25-04-25>

-- TODO: Add a keymap to generate the documentation for a package <11-06-25>

-- BUG: Bug that changes the directory must be in the find the project root function. A possible alternative would be to
-- use the function as is used in the neovim core LSP implementation the find the root according to project markers.
-- perhaps a local mapping does not get set for the terminal... <19-10-24>

-- TODO: Add keymap for testing the current test file via `ARGS`. It should be checked if in the test file otherwise it
-- should call the last test file that was visited. <05-06-25>

-- TODO: Add autopairs `endwise` rules for "begin end" groups and for "do end"
-- https://github.com/windwp/nvim-autopairs/wiki/Endwise#list-rule-predefined-by-user <11-05-23>

-- TODO: Add a special notification title and icon for notifications that are linked to julia. See `h snacks-notifier` <20-06-25>

local term = require 'util.terminal'

-- TODO: Terminal send keymap with motion support <16-04-25>

local JULIA_PROJECT_REPL_CMD = 'fish -c "julia +1.12 --project --threads auto"'
local JULIA_REPL_CMD = 'fish -c "julia +1.12"'

vim.api.nvim_buf_create_user_command(0, 'JuliaREPL', function()
  term.toggle_repl(JULIA_PROJECT_REPL_CMD, '¶', {}, '¶')
end, { nargs = '?' })

-- NOTE: <RightAlt + r>
vim.keymap.set('n', '¶', function()
  term.toggle_repl(JULIA_PROJECT_REPL_CMD, '¶', {}, '¶')
end, { desc = 'Julia REPL for project', buffer = true })

vim.keymap.set('n', 'g¶', function()
  term.toggle_repl(JULIA_PROJECT_REPL_CMD, '¶', {
    env = {
      ['JULIA_DOCUMENTING'] = true,
    },
  }, 'g¶')
end, { desc = 'Julia project REPL for documentation', buffer = true })

-- NOTE: <LocalLeader><RightAlt + r>
vim.keymap.set('n', '<LocalLeader>¶', function()
  term.toggle_repl(JULIA_REPL_CMD, '<localleader>¶', {}, '<localleader>¶')
end, { desc = 'Julia REPL toggle', buffer = true })

vim.keymap.set('n', '<LocalLeader>t', function()
  term.oneshot(
    'fish -c "julia +1.12 --project --eval \'using Pkg; Pkg.test()\'"',
    vim.tbl_extend('keep', term.DEFAULT_REPL_OPTS, {
      start_insert = false,
      auto_insert = false,
      auto_close = false,
      interactive = true,
    })
  )
end, { desc = 'Run PACKAGE tests', buffer = true })

vim.keymap.set('n', '<LocalLeader>T', function()
  term.oneshot(
    'fish -c "julia +1.12 --project --eval \'using Pkg; Pkg.test()\'"',
    vim.tbl_extend('keep', term.DEFAULT_REPL_OPTS, {
      env = { ['RUNTESTS_FULL'] = true },
      start_insert = false,
      auto_insert = false,
      auto_close = false,
      interactive = true,
    })
  )
end, { desc = 'Run ALL tests (RUNTESTS_FULL=1)', buffer = true })

vim.keymap.set('n', '<LocalLeader>gT', function()
  term.oneshot(
    'fish -c "julia +1.12 --project --eval \'using Pkg; Pkg.test()\'"',
    vim.tbl_extend('keep', term.DEFAULT_REPL_OPTS, {
      env = { ['RUNTESTS_FULL'] = true, ['FIX_DOCTESTS'] = true },
      start_insert = false,
      auto_insert = false,
      auto_close = false,
      interactive = true,
    })
  )
end, { desc = 'Run ALL tests and fix doctests (RUNTESTS_FULL=1, FIX_DOCTESTS=1)', buffer = true })

_G.JULIA_TEST_ARGS_LAST = nil
-- TODO: Add name of the window from the arguments to the window options #quickfix <11-06-25>
-- TODO: Add completion via the `:command-completion` "custom,func" option. We have to have the test folder for this <14-07-25>
-- FIX: rerun command does not work <10-06-25>
vim.keymap.set('n', '<LocalLeader>gt', function()
  vim.ui.input({ prompt = 'Fill `test_args`', default = _G.JULIA_TEST_ARGS_LAST }, function(input)
    input = input or ''
    local test_args = string.len(input) == 0 and '' or string.format('test_args=[%q]', input)
    if string.len(test_args) ~= 0 then
      vim.notify('Testing with `test_args`: `' .. string.format('[%s]', input) .. '`')
    end
    _G.JULIA_TEST_ARGS_LAST = input
    local command = 'fish -c "julia +1.12 --project --eval \'using Pkg; Pkg.test(' .. test_args .. ')\'"'
    local run_tests_function
    local rerun_keys = {
      win = {
        keys = {
          rerun = {
            'R',
            function()
              run_tests_function()
            end,
            mode = { 'n', 't' },
            desc = 'Window: navigate right',
          },
        },
      },
    }
    run_tests_function = function()
      term.oneshot(
        command,
        vim.tbl_extend('keep', term.DEFAULT_REPL_OPTS, {
          start_insert = false,
          auto_insert = false,
          auto_close = false,
          interactive = true,
        }, rerun_keys)
      )
    end
    run_tests_function()
  end)
end, { desc = 'Run tests selected tests', buffer = true })
