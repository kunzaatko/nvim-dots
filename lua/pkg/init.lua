-- TODO: Add more mappings to '<leacer>' with which-key <16-01-22, kunzaatko> --
-- TODO: Better way how to manage dependencies. Especially for lsp parts <16-01-22, kunzaatko> --
-- TODO: Auto document into the README.file <16-01-22, kunzaatko> --
-- TODO: More contrast color between windows (fillchars separators) <16-01-22, kunzaatko> --
local packer = require 'packer'
return packer.startup {
  function()
    local use = packer.use

    -- package management --

    -- manage packer as optional plug-in
    use {
      'wbthomason/packer.nvim',
      opt = true,
      config = function()
        -- TODO: Add profiling and do not spell in profile windows <13-12-21, kunzaatko> --
        vim.cmd [[autocmd FileType packer lua vim.opt_local.spell = false]]
      end,
    }

    -- LANGUAGES {{{
    -- FIX: There is a bug that causes this to give errors when it is an opt plug-in on several events
    -- <17-11-21, kunzaatko> --
    -- use {'JuliaEditorSupport/julia-vim', as = 'julia'} -- mainly for LaTeX to Unicode support

    -- 'rust-lang/rust.vim' -- Playpen integration, :RunTest{{{
    use {
      'rust-lang/rust.vim',
      as = 'rust',
      ft = 'rust',
      config = function()
        vim.g.rustfmt_autosave = 1
      end,
    }
    -- }}}

    -- 'simrat39/rust-tools.nvim' -- LSP rust specifics{{{
    use {
      'simrat39/rust-tools.nvim',
      ft = 'rust',
      config = function()
        require('rust-tools').setup()
      end,
      requires = {
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope.nvim',
        'neovim/nvim-lspconfig',
      },
    }
    -- }}}

    -- 'lervag/vimtex' -- continuous compilation, folding, indenting etc.{{{
    use {
      'lervag/vimtex',
      ft = 'tex',
      setup = function()
        require 'conf.pkgs.vimtex'
      end,
    }
    -- }}}

    -- 'kovetskiy/sxhkd-vim' -- SXHKD spec file support{{{
    use {
      'kovetskiy/sxhkd-vim',
      as = 'sxhkd',
      ft = 'sxhkd',
      setup = function()
        -- NOTE: Fix the SXHKD filetype detection issue <kunzaatko> --
        _G.AUtils.check_ft_sxhkd = function()
          if packer_plugins['plenary.nvim'].loaded ~= true then
            vim.cmd [[packadd plenary.nvim]]
          end
          local p = require('plenary').path.new(vim.api.nvim_buf_get_name(0))
          if p:_split()[#p:_split()] == 'sxhkdrc' then
            vim.opt.filetype = 'sxhkd'
          end
        end

        vim.cmd [[ autocmd BufRead * call v:lua.AUtils.check_ft_sxhkd() ]]
      end,
    }
    -- }}}

    -- TOML language support
    use { 'cespare/vim-toml', as = 'toml', ft = 'toml' }
    -- fish scripts support
    use { 'blankname/vim-fish', as = 'fish', ft = 'fish' }

    -- }}}

    -- LSP, COMPLETION, LINTING AND FORMATTING {{{
    -- 'folke/trouble.nvim' -- diagnostics and quickfix-list {{{
    use {
      'folke/trouble.nvim',
      requires = 'kyazdani42/nvim-web-devicons',
      cmd = { 'Trouble', 'TroubleToggle', 'TroubleClose', 'TroubleRefresh' },
      keys = { '<leader>tt', '<leader>tl', '<leader>tr', '<leader>td' },
      setup = function()
        local wk = require 'which-key'
        wk.register({
          t = {
            name = 'Trouble',
            t = { 'Toggle' },
            l = { 'Lsp document diagnostics' },
            r = { 'Lsp references' },
            d = { 'Lsp definitions' },
          },
        }, { prefix = '<leader>' })
      end,
      config = function()
        -- Trouble 'global' (full workspace diagnostics)
        vim.api.nvim_set_keymap('n', '<Leader>tt', '<Cmd>TroubleToggle<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap(
          'n',
          '<Leader>tl',
          '<Cmd>TroubleToggle document_diagnostics<CR>',
          { noremap = true, silent = true }
        ) -- Trouble 'local' (only the current buffer)
        vim.api.nvim_set_keymap(
          'n',
          '<Leader>tr',
          '<Cmd>TroubleToggle lsp_references<CR>',
          { noremap = true, silent = true }
        ) -- Trouble references
        vim.api.nvim_set_keymap(
          'n',
          '<Leader>td',
          '<Cmd>TroubleToggle lsp_definitions<CR>',
          { noremap = true, silent = true }
        ) -- Trouble definitions
      end,
    }
    -- }}}

    -- TODO: Show snippets first in sorted <16-01-22, kunzaatko> --
    -- TODO: Better colours in menu <16-01-22, kunzaatko> --
    -- 'hrsh7th/nvim-cmp' -- completion engine {{{
    use {
      'hrsh7th/nvim-cmp',
      as = 'cmp',
      requires = {
        { 'hrsh7th/cmp-buffer' },
        -- FIX: How to do this better? <16-01-22, kunzaatko> --
        {
          'nvim-lua/lsp-status.nvim',
          config = function()
            require('lsp-status').config {
              show_filename = false,
              current_function = false,
              diagnostics = false,
              status_symbol = '',
              spinner_frames = { '◓', '◑', '◒', '◐' },
            }
          end,
        },
        { 'hrsh7th/cmp-path' },
        { 'hrsh7th/cmp-cmdline' },
        { 'quangnguyen30192/cmp-nvim-ultisnips', after = 'cmp' },
        { 'petertriho/cmp-git', requires = 'nvim-lua/plenary.nvim' },
        { 'kdheepak/cmp-latex-symbols' },
        { 'lukas-reineke/cmp-rg' },
        { 'f3fora/cmp-spell' },
        { 'tzachar/cmp-tabnine', run = './install.sh' },
        { 'hrsh7th/cmp-nvim-lsp' },
        { 'neovim/nvim-lspconfig' },
      },
      config = function()
        require 'conf.pkgs.nvim_cmp'
      end,
    }
    -- }}}

    -- 'nvim-treesitter/nvim-treesitter' -- treesitter code parsing and refactoring {{{
    use {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
      config = function()
        require 'conf.pkgs.treesitter'
      end,
    }
    -- }}}

    -- navigation objects from treesitter
    use { 'nvim-treesitter/nvim-treesitter-textobjects', requires = 'nvim-treesitter' }

    -- colour paired delimiters
    use { 'p00f/nvim-ts-rainbow', requires = 'nvim-treesitter' }

    -- 'nvim-treesitter/playground' -- see the treesitter tree live {{{
    use {
      'nvim-treesitter/playground',
      setup = function()
        local wk = require 'which-key'
        wk.register({ C = { 'Highlight captures' } }, { prefix = '<leader>' })
      end,
      config = function()
        vim.api.nvim_set_keymap(
          'n',
          '<leader>C',
          '<Cmd>TSHighlightCapturesUnderCursor<CR>',
          { silent = true, noremap = true }
        )
      end,
      requires = 'nvim-treesitter',
    }
    -- }}}

    -- TODO: Is this needed anymore? <16-01-22, kunzaatko> --
    -- 'nvim-lua/lsp_extensions' -- rust type annotations {{{
    use {
      'nvim-lua/lsp_extensions.nvim',
      ft = 'rust',
      config = function()
        require('lsp_extensions').inlay_hints()
        --luacheck: no max line length
        vim.cmd [[
                augroup RustTypeHints
                    autocmd!
                    autocmd InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *.rs lua require'lsp_extensions'.inlay_hints{ prefix = ' » ', highlight = "NonText", enabled = {"ChainingHint"} }
                augroup END
        ]]
        --luacheck: max line length 120
      end,
    }
    -- }}}

    -- TODO: Do not show if it is only gitsigns code action (it is everywhere) (null-ls blame-line)
    -- <16-01-22, kunzaatko> --
    -- 'kosayoda/nvim-lightbulb' -- code action discovery {{{
    use {
      'kosayoda/nvim-lightbulb',
      config = function()
        require('nvim-lightbulb').update_lightbulb {
          sign = { enabled = true, priority = 10 },
          float = { enabled = true, text = ' ' },
          virtual_text = { enabled = true, text = ' ', hl_mode = 'replace' },
          status_text = { enabled = true, text = ' ', text_unavailable = '' },
        }
        vim.fn.sign_define('LightBulbSign', { text = ' ', texthl = 'DiagnosticInfo' }) -- 
        --luacheck: no max line length
        vim.cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb({ignore = {"null-ls"}})]]
        --luacheck: max line length 120
      end,
    }
    -- }}}

    -- development environment for lua and nvim
    use { 'folke/lua-dev.nvim', as = 'lua-dev' }

    -- 'lewis6991/spellsitter.nvim' -- use the inbuilt neovim spellchecker with treesitter {{{
    use {
      'lewis6991/spellsitter.nvim',
      config = function()
        require('spellsitter').setup { spellchecker = 'vimfn' }
      end,
    }
    -- }}}

    -- 'jose-elias-alvarez/null-ls.nvim' -- for attaching command line utilities to nvim LSP client api {{{
    use {
      'jose-elias-alvarez/null-ls.nvim',
      config = function()
        local null_ls = require 'null-ls'
        require 'utils.lsputils'
        require('null-ls').setup {
          on_attach = _G.LSPUtils.on_attach,
          sources = {
            null_ls.builtins.formatting.clang_format,
            null_ls.builtins.formatting.fish_indent,
            null_ls.builtins.formatting.prettier,
            null_ls.builtins.diagnostics.chktex,
            null_ls.builtins.formatting.yapf,
            null_ls.builtins.formatting.rustfmt,
            null_ls.builtins.diagnostics.vale,
            null_ls.builtins.formatting.stylua.with {
              extra_args = { '--config-path', vim.fn.expand '~/.config/stylua.toml' },
            },
            null_ls.builtins.formatting.taplo,
            -- FIX: Messess up formatting because their is a conflict -- multiple
            -- sources <19-02-22, kunzaatko> --
            -- null_ls.builtins.formatting.codespell.with {
            --   disabled_filetypes = { 'tex' },
            -- },
            null_ls.builtins.formatting.reorder_python_imports,
            null_ls.builtins.diagnostics.mypy,
            null_ls.builtins.formatting.shellharden,
            null_ls.builtins.formatting.shfmt,
            null_ls.builtins.diagnostics.cppcheck,
            null_ls.builtins.diagnostics.luacheck,
            null_ls.builtins.diagnostics.markdownlint,
            null_ls.builtins.diagnostics.misspell,
            -- null_ls.builtins.diagnostics.proselint,
            null_ls.builtins.diagnostics.pylint,
            null_ls.builtins.diagnostics.shellcheck,
            null_ls.builtins.diagnostics.stylelint,
            -- null_ls.builtins.diagnostics.write_good,
            null_ls.builtins.diagnostics.yamllint,
            null_ls.builtins.code_actions.gitsigns,
            null_ls.builtins.code_actions.proselint,
            null_ls.builtins.code_actions.shellcheck,
            null_ls.builtins.hover.dictionary,
          },
        }
        -- FIX: Julia bug julia-vscode/julia-vscode#2526 crashes the server -> Julia cannot be
        -- autoformatted <19-02-22, kunzaatko> --
        vim.cmd [[
            augroup FormatAutogroup
                autocmd!
                autocmd! BufWritePre *.rs,*.lua,*.py,*.toml,*.tex,*.fish lua vim.lsp.buf.formatting_sync()
            augroup END
                ]]
      end,
      requires = { 'nvim-lua/plenary.nvim' },
    }
    -- }}}
    -- }}}

    -- PRETTIFYING {{{

    -- TODO: Highlight in popupdocs of LSP <16-01-22, kunzaatko> --
    -- 'norcalli/nvim-colorizer.lua' -- colours visualizer {{{
    use {
      'norcalli/nvim-colorizer.lua',
      ft = { 'css', 'javascript', 'vim', 'html', 'lua', 'tex', 'cfg', 'dosini', 'sh' },
      config = function()
        require('colorizer').setup({
          'css',
          'javascript',
          'html',
          'dosini',
          'tex',
          'cfg',
          'sh',
          vim = { names = false, hsl_fn = true },
          lua = { names = false, hsl_fn = true },
        }, { mode = 'foreground' })
      end,
    }
    -- }}}

    use { 'godlygeek/tabular', cmd = 'Tabularize' }
    -- }}}

    -- SESSIONS AND CONVENIENCES {{{
    -- TODO: Better with 'dashboard.nvim' plugin? <16-01-22, kunzaatko> --
    -- 'mhinz/vim-startify'-- launch page{{{
    use {
      'mhinz/vim-startify',
      setup = function()
        vim.g.startify_fortune_use_unicode = 1
      end,
    }
    -- }}}

    -- 'mbbill/undotree' -- undotree visualizer {{{
    use {
      'mbbill/undotree',
      cmd = 'UndotreeToggle',
      keys = '<leader>u',
      setup = function()
        vim.g.undotree_WindowLayout = 2 -- layout with diff at the bottom
        vim.g.undotree_DiffpanelHeight = 7 -- most of the time only one line changes
        vim.g.undotree_ShortIndicators = 1 -- time indicators 's,m,h,d'
        vim.g.undotree_SplitWidth = 40 -- it fits 3 branches
        vim.g.undotree_TreeNodeShape = ''
        vim.g.undotree_TreeVertShape = '│'
        vim.g.undotree_DiffAutoOpen = 0 -- it does not carry much info
        vim.g.undotree_SetFocusWhenToggle = 1 -- better for using it for complicated undo and not informative
        vim.g.undotree_HelpLine = 0 -- do not show the help line hint
        local wk = require 'which-key'
        wk.register({ u = {
          'UndoTree toggle',
        } }, { prefix = '<leader>' })
      end,
      config = function()
        vim.api.nvim_set_keymap('n', '<leader>u', '<Cmd>UndotreeToggle<CR>', { noremap = true, silent = true })
      end,
    }
    -- }}}

    -- 'folke/which-key.nvim' -- echo keymappings {{{
    use {
      'folke/which-key.nvim',
      config = function()
        -- TODO: configure https://github.com/folke/which-key.nvim <28-04-21, kunzaatko> --
        require('which-key').setup {
          plugins = { spelling = { enabled = true } },
          window = { border = 'double', margin = { 0, 0, 0, 0 } },
          ignore_missing = true,
        }
      end,
    }
    -- }}}

    -- }}}

    -- AESTHETICS {{{

    -- 'rebelot/heirline.nvim' -- status line {{{
    use {
      'rebelot/heirline.nvim',
      config = function()
        local statusline = require 'conf.pkgs.heirline'
        require('heirline').setup(statusline)
      end,
      after = 'lush.nvim',
      requires = {
        { 'kyazdani42/nvim-web-devicons' },
        { 'rktjmp/lush.nvim' },
        {
          'SmiteshP/nvim-gps',
          requires = 'nvim-treesitter/nvim-treesitter',
          config = function()
            require('nvim-gps').setup {
              icons = { -- {{{
                ['string-name'] = '  ',
                ['class-name'] = '  ',
                ['function-name'] = '  ',
                ['method-name'] = '  ',
                ['array-name'] = '  ',
                ['container-name'] = '  ',
                ['table-name'] = '  ',
                ['object-name'] = '  ',
                ['inline-table-name'] = '  ',
                ['tag-name'] = '  ',
                ['boolean-name'] = '  ',
                ['number-name'] = '  ',
                ['integer-name'] = '  ',
                ['time-name'] = '  ',
              }, -- }}}
              separator = ' ⟩ ',
              depth = 4,
              depth_limit_indicator = ' ',
            }
          end,
        },
      },
    }
    -- }}}

    -- 'folke/zen-mode.nvim' --  focus mode{{{
    use {
      'folke/zen-mode.nvim',
      cmd = { 'ZenMode' },
      keys = '<leader>z',
      setup = function()
        local wk = require 'which-key'
        wk.register({ z = { 'ZenMode' } }, { prefix = '<leader>' })
      end,
      config = function()
        require('zen-mode').setup {
          -- TODO: configure https://github.com/folke/zen-mode.nvim <26-07-21, kunzaatko> --
          window = {
            width = 0.85,
          },
        }
        vim.api.nvim_set_keymap('n', '<leader>z', '<Cmd>ZenMode<CR>', { noremap = true, silent = true })
      end,
    }
    -- }}}

    -- 'lukas-reineke/indent-blankline.nvim' -- indentation guides {{{
    use {
      'lukas-reineke/indent-blankline.nvim',
      setup = function()
        vim.g.indent_blankline_char = '│'
        vim.g.indent_blankline_use_treesitter = true
        vim.g.indent_blankline_show_first_indent_level = false
        vim.g.indent_blankline_filetype_exclude = { 'help', 'markdown', 'txt' }
        vim.g.indent_blankline_buftype_exclude = { 'terminal' }
        vim.g.indent_blankline_space_char = '·'
        vim.opt.colorcolumn = '999999' -- fix: for https://github.com/lukas-reineke/indent-blankline.nvim/issues/59
      end,
    }
    -- }}}

    -- 'folke/todo-comments.nvim' -- todo comments and todo quickfix-list {{{
    use {
      'folke/todo-comments.nvim',
      requires = 'nvim-lua/plenary.nvim',
      config = function()
        require('todo-comments').setup {
          highlight = { keyword = 'fg', after = '' },
          keywords = {
            FIX = {
              icon = ' ',
              color = 'error',
              alt = { 'FIXME', 'BUG', 'FIXIT', 'ISSUE' },
            },
            TODO = { icon = ' ', color = 'info' },
            HACK = { icon = ' ', color = 'warning' },
            WARN = { icon = ' ', color = 'warning', alt = { 'WARNING', 'XXX' } },
            PERF = { icon = ' ', alt = { 'OPTIM', 'PERFORMANCE', 'OPTIMIZE' } },
            NOTE = { icon = ' ', color = 'hint', alt = { 'INFO' } },
          },
        }
      end,
    }
    -- }}}

    -- 'rcarriga/nvim-notify' -- notification UI for neovim {{{
    use {
      'rcarriga/nvim-notify',
      as = 'notify',
      config = function()
        vim.notify = require 'notify'
      end,
    }
    -- }}}

    -- TODO: Change style of font in active tab <28-11-21, kunzaatko> --
    -- TODO: Mappings to remove buffer also from bufferline <16-01-22, kunzaatko> --
    -- TODO: Make this work with auto-session <16-01-22, kunzaatko> --
    -- 'akinsho/bufferline.nvim' -- buffer symbols and nicer UI {{{
    use {
      'akinsho/bufferline.nvim',
      requires = 'kyazdani42/nvim-web-devicons',
      config = function()
        require('bufferline').setup {
          options = {
            numbers = function(opts)
              return string.format('%s·%s', opts.ordinal, opts.lower(opts.id))
            end,
            always_show_bufferline = false,
            show_close_icon = false,
            buffer_close_icon = '',
            close_icon = '',
            show_buffer_clos_icon = false,
            custom_filter = function(buf_number)
              if vim.bo[buf_number].filetype ~= 'startify' then
                return true
              end
            end,
          },
        }
        vim.api.nvim_set_keymap('n', '<leader>b', '<Cmd>BufferLinePick<CR>', { noremap = true, silent = true })
        local keys = { '+', 'ě', 'š', 'č', 'ř', 'ž', 'ý', 'á', 'í' }
        for i = 1, 9 do
          vim.api.nvim_set_keymap(
            'n',
            '<leader>' .. keys[i],
            '<Cmd>BufferLineGoToBuffer ' .. tostring(i) .. '<CR>',
            { noremap = true, silent = true }
          )
        end
      end,
    }
    -- }}}

    -- disable search highlight when done with searching
    use 'romainl/vim-cool'

    ----------------------
    --  colour-schemes  --
    ----------------------
    -- 'npxbr/gruvbox.nvim' -- colour-scheme {{{
    use {
      'npxbr/gruvbox.nvim',
      requires = { 'rktjmp/lush.nvim' },
      config = function()
        vim.cmd 'colorscheme gruvbox'
      end,
      after = { 'lush.nvim' },
      cond = 'false',
    }
    -- }}}

    -- 'kunzaatko/nord.nvim' -- colour-scheme {{{
    use {
      '~/.config/nvim/pack/opt/nord-vim',
      requires = { 'rktjmp/lush.nvim', opt = true },
      setup = function()
        vim.g.nord_italic = 1
        vim.g.nord_italic_comments = 1
        vim.g.nord_cursor_line_number_background = 1
        vim.g.nord_underline = 1
        vim.g.nord_langs = {
          'c',
          'cmake',
          'gitconfig',
          'gitcommit',
          'go',
          'help',
          'sh',
          'vim',
          'yaml',
          'html',
          'lua',
          'markdown',
          'json',
          'python',
          'rust',
        }
        vim.g.nord_pkgs = { 'gitsigns', 'vim-startify', 'tree-sitter', 'cmp', 'vimtex' }
      end,
      config = function()
        vim.cmd 'colorscheme nord'
      end,
    }
    -- }}}
    -- }}}

    -- MOVEMENT {{{

    -- TODO: Setup highlights <16-01-22, kunzaatko> --
    -- 'ggandor/lightspeed.nvim' -- enhanced f,F,t,T and s,S for double letter searching {{{
    use {
      'ggandor/lightspeed.nvim',
      keys = { 's', 'S', 'f', 'F', 't', 'T' },
      requires = 'tpope/vim-repeat',
    }
    -- }}}

    -- 'karb94/neoscroll.nvim' -- for smooth scrolling {{{
    use {
      'karb94/neoscroll.nvim',
      config = function()
        require('neoscroll').setup()
      end,
    }
    -- }}}

    -- TODO: Add transparency to default UI <16-01-22, kunzaatko> --
    -- 'nvim-telescope/telescope.nvim' -- file finder and list shower {{{
    use {
      'nvim-telescope/telescope.nvim',
      keys = {
        '<leader>fs',
        '<leader>fw',
        '<leader>fF',
        '<leader>fg',
        '<leader>fb',
        '<leader>fh',
        '<leader>ff',
        '<leader>fk',
        '<leader><leader>',
      },
      cmd = 'Telescope',
      requires = {
        'nvim-lua/plenary.nvim',
        { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
        'nvim-treesitter/nvim-treesitter',
      },
      setup = function()
        local wk = require 'which-key'
        wk.register({
          f = {
            name = 'Telescope',
            s = { 'Spelling' },
            F = {
              'Find files',
            },
            g = { 'Live grep' },
            w = { 'Workspace files' },
            b = { 'Buffers' },
            h = { 'Help tags' },
            f = { 'Pickers' },
            k = { 'Keymaps' },
            ['<leader>'] = { 'Fuzzy buffer' },
          },
        }, { prefix = '<leader>' })
      end,
      config = function()
        vim.cmd [[packadd trouble.nvim]]
        local trouble = require 'trouble.providers.telescope'
        require('telescope').setup {
          defaults = {
            mappings = {
              i = { ['<C-q>'] = trouble.open_with_trouble },
              n = { ['<C-q>'] = trouble.open_with_trouble },
            },
          },
        }
        require('telescope').load_extension 'fzf'

        if packer_plugins.notify.loaded == true then
          -- TODO: Defer the loading of this extension when notify is loaded <03-12-21, kunzaatko> --
          require('telescope').load_extension 'notify'
        end

        vim.api.nvim_set_keymap(
          'n',
          '<leader>fs',
          "<Cmd>lua require'telescope.builtin'.spell_suggest()<CR>",
          { noremap = true, silent = true }
        )
        vim.api.nvim_set_keymap(
          'n',
          '<leader>fw',
          "<Cmd>lua require'telescope.builtin'.git_files()<CR>",
          { noremap = true, silent = true }
        )
        vim.api.nvim_set_keymap(
          'n',
          '<leader>fF',
          "<Cmd>lua require'telescope.builtin'.find_files()<CR>",
          { noremap = true, silent = true }
        )
        vim.api.nvim_set_keymap(
          'n',
          '<leader>fg',
          "<Cmd>lua require'telescope.builtin'.live_grep()<CR>",
          { noremap = true, silent = true }
        )
        vim.api.nvim_set_keymap(
          'n',
          '<leader>fb',
          "<Cmd>lua require'telescope.builtin'.buffers()<CR>",
          { noremap = true, silent = true }
        )
        vim.api.nvim_set_keymap(
          'n',
          '<leader>fh',
          "<Cmd>lua require'telescope.builtin'.help_tags()<CR>",
          { noremap = true, silent = true }
        )
        vim.api.nvim_set_keymap(
          'n',
          '<leader>ff',
          "<Cmd>lua require'telescope.builtin'.builtin()<CR>",
          { noremap = true, silent = true }
        )
        vim.api.nvim_set_keymap(
          'n',
          '<leader>fk',
          "<Cmd>lua require'telescope.builtin'.keymaps()<CR>",
          { noremap = true, silent = true }
        )
        vim.api.nvim_set_keymap(
          'n',
          '<leader><leader>',
          "<Cmd>lua require'telescope.builtin'.current_buffer_fuzzy_find()<CR>",
          { noremap = true, silent = true }
        )
      end,
    }

    -- }}}

    -- 'luukvbaal/stabilize.nvim' -- stabilizes the widnows on split creation {{{
    use {
      'luukvbaal/stabilize.nvim',
      config = function()
        require('stabilize').setup()
      end,
    } --}}}

    -- }}}

    -- TEXT-EDITING FEATURES {{{

    -- TODO: Configure <16-01-22, kunzaatko> --
    -- 'windwp/nvim-autopairs' -- automatically adding matching delimiters {{{
    use {
      'windwp/nvim-autopairs',
      event = 'InsertEnter',
      config = function()
        require('nvim-autopairs').setup()
      end,
    }
    -- }}}

    -- TODO: Add repeat capability <16-01-22, kunzaatko> --
    -- 'blackCauldron7/surround.nvim' -- text objects and editing surrounding delimiters{{{
    use {
      'ur4ltz/surround.nvim',
      config = function()
        require('surround').setup { mappings_style = 'surround' }
      end,
    }
    -- }}}

    -- 'b3nj5m1n/kommentary' -- commenting {{{
    use {
      'b3nj5m1n/kommentary',
      config = function()
        require('kommentary.config').configure_language('default', { prefer_single_line_comments = true })
      end,
    }
    -- }}}

    -- abbreviations
    -- TODO: Do this in lua <16-01-22, kunzaatko> --
    use 'tpope/vim-abolish'
    -- }}}

    -- SNIPPETS {{{
    -- TODO: Todo comment expand at beginning of line <16-01-22, kunzaatko> --
    -- TODO: Add '<leader>' mappings for editing snippet files <16-01-22, kunzaatko> --
    -- 'sirver/ultisnips' -- snippets {{{
    use {
      'sirver/ultisnips',
      event = 'InsertEnter',
      setup = function()
        -- Snippets variables
        vim.g.snips_author = 'kunzaatko'
        vim.g.snips_email = 'martinkunz@email.cz'
        vim.g.snips_github = 'https://github.com/kunzaatko'
        -- UltiSnips
        vim.opt.runtimepath = vim.opt.runtimepath + { vim.fn.expand '$PWD' }
        vim.g.UltiSnipsSnippetDirectories = { 'snips' } -- ensure that snippets directories are not recursively searched
        vim.g.UltiSnipsEnableSnipMate = 0 -- only look for UltiSnips snippets
        vim.g.UltiSnipsExpandTrigger = '<Plug>(ultisnips_expand)'
        vim.g.UltiSnipsJumpForwardTrigger = '<Plug>(ultisnips_jump_forward)'
        vim.g.UltiSnipsJumpBackwardTrigger = '<Plug>(ultisnips_jump_backward)'
        vim.g.UltiSnipsRemoveSelectModeMappings = 0 -- for using tab in nvim-cmp
      end,
      config = function()
        if vim.bo.filetype == 'tex' then
          vim.g.UltiSnipsSnippetStorageDirectoryForUltiSnipsEdit = _G.TEXUtils.get_tex_root():joinpath('snips').filename
        end
        vim.api.nvim_set_keymap(
          'x',
          '<C-l>',
          ':lua vim.call("UltiSnips#SaveLastVisualSelection")<CR>gvs',
          { noremap = true, silent = true }
        )
        vim.api.nvim_set_keymap(
          's',
          '<C-l>',
          ':lua vim.call("UltiSnips#ExpandSnippet")<CR>',
          { noremap = true, silent = true }
        )
      end,
    }
    -- }}}

    -- TODO: Module documentation generation <16-01-22, kunzaatko> --
    -- 'danymat/neogen' -- generate documentation for functions based on treesitter {{{
    use {
      'danymat/neogen',
      keys = { '<leader>dd', '<leader>dc', '<leader>df', '<leader>dt' },
      setup = function()
        local wk = require 'which-key'
        wk.register({
          d = {
            name = 'DocGen',
            d = { 'Generate' },
            c = { 'Class' },
            f = { 'Function' },
            t = { 'Type' },
          },
        }, { prefix = '<leader>' })
      end,
      config = function()
        require('neogen').setup { enabled = true }
        vim.api.nvim_set_keymap(
          'n',
          '<leader>dd',
          "<Cmd>lua require'neogen'.generate()<CR>",
          { noremap = true, silent = true }
        )
        vim.api.nvim_set_keymap(
          'n',
          '<leader>dc',
          "<Cmd>lua require'neogen'.generate({ type = 'class' })<CR>",
          { noremap = true, silent = true }
        )
        vim.api.nvim_set_keymap(
          'n',
          '<leader>df',
          "<Cmd>lua require'neogen'.generate({ type = 'func' })<CR>",
          { noremap = true, silent = true }
        )
        vim.api.nvim_set_keymap(
          'n',
          '<leader>dt',
          "<Cmd>lua require'neogen'.generate({ type = 'type' })<CR>",
          { noremap = true, silent = true }
        )
        vim.api.nvim_set_keymap(
          'n',
          '<C-l>',
          "<Cmd>lua require'neogen'.jump_next()<CR>",
          { noremap = true, silent = true }
        )
      end,
      requires = 'nvim-treesitter/nvim-treesitter',
    }
    -- }}}

    -- }}}

    -- GIT {{{
    -- TODO: configure <03-03-22, kunzaatko> --
    -- 'TimUntersberger/neogit' -- magit for neovim {{{
    use {
      'TimUntersberger/neogit',
      cmd = 'Neogit',
      keys = { '<leader>gg', '<leader>gc' },
      requires = 'sindrets/diffview.nvim',
      setup = function()
        local wk = require 'which-key'
        wk.register({
          g = {
            name = 'NeoGit',
            g = { 'open' },
            c = { 'commit pop-up' },
          },
        }, { prefix = '<leader>' })
      end,
      config = function()
        vim.cmd [[
        autocmd FileType NeogitStatus,NeogitPopup lua vim.opt_local.spell = false; vim.opt_local.list = false
        ]]
        require('neogit').setup {
          disable_hint = true,
          disable_builtin_notifications = true,
          disable_commit_confirmation = true,
          commit_popup = { kind = 'vsplit' },
          integrations = { diffview = true },
        }
        -- TODO: Do this with which-key <03-03-22, kunzaatko> --
        vim.api.nvim_set_keymap(
          'n',
          '<leader>gg',
          "<Cmd> lua require'neogit'.open()<CR>",
          { noremap = true, silent = true }
        )
        vim.api.nvim_set_keymap(
          'n',
          '<leader>gc',
          "<Cmd> lua require'neogit'.open({'commit'})<CR>",
          { noremap = true, silent = true }
        )
      end,
    }
    -- }}}

    -- 'sindrets/diffview.nvim' -- viewing diff of files in tree {{{
    use {
      'sindrets/diffview.nvim',
      config = function()
        local MUtils = _G.MUtils
        local cb = require('diffview.config').diffview_callback
        MUtils.close_diffview = function()
          vim.cmd [[tabclose]]
        end
        require('diffview').setup {
          key_bindings = {
            disable_defaults = true,
            view = {
              ['q'] = '<Cmd>lua _G.MUtils.close_diffview()<CR>',
              ['<esc>'] = '<Cmd>lua _G.MUtils.close_diffview()<CR>',
              ['<leader><leader>'] = cb 'toggle_files',
            },
            file_panel = {
              ['q'] = '<Cmd>lua _G.MUtils.close_diffview()<CR>',
              ['<esc>'] = '<Cmd>lua _G.MUtils.close_diffview()<CR>',
              ['j'] = cb 'next_entry',
              ['<down>'] = cb 'next_entry',
              ['k'] = cb 'prev_entry',
              ['<up>'] = cb 'prev_entry',
              ['<cr>'] = cb 'select_entry',
              ['o'] = cb 'select_entry',
              ['<2-LeftMouse>'] = cb 'select_entry',
              ['<tab>'] = cb 'select_next_entry',
              ['<s-tab>'] = cb 'select_prev_entry',
              ['i'] = cb 'listing_style',
              ['f'] = cb 'toggle_flatten_dirs',
              ['<leader><leader>'] = cb 'toggle_files',
            },
            file_history_panel = {
              ['q'] = '<Cmd>lua _G.MUtils.close_diffview()<CR>',
              ['<esc>'] = '<Cmd>lua _G.MUtils.close_diffview()<CR>',
              ['g!'] = cb 'options',
              ['y'] = cb 'copy_hash',
              ['zR'] = cb 'open_all_folds',
              ['zM'] = cb 'close_all_folds',
              ['j'] = cb 'next_entry',
              ['<down>'] = cb 'next_entry',
              ['k'] = cb 'prev_entry',
              ['<up>'] = cb 'prev_entry',
              ['<cr>'] = cb 'select_entry',
              ['o'] = cb 'select_entry',
              ['<2-LeftMouse>'] = cb 'select_entry',
              ['<tab>'] = cb 'select_next_entry',
              ['<s-tab>'] = cb 'select_prev_entry',
              ['<leader><leader>'] = cb 'toggle_files',
            },
            option_panel = { ['<tab>'] = cb 'select', ['q'] = cb 'close' },
          },
          hooks = {
            diff_buf_read = function()
              vim.opt_local.spell = false
              vim.opt_local.list = false
            end,
          },
        }
      end,
    }
    -- }}}

    -- 'lewis6991/gitsigns.nvim' -- signs of changes in sign column {{{
    use {
      'lewis6991/gitsigns.nvim',
      requires = 'nvim-lua/plenary.nvim',
      setup = function()
        vim.cmd 'packadd plenary.nvim'
        local wk = require 'which-key'
        wk.register({
          h = {
            name = 'Hunk',
            b = { 'Blame line' },
            p = { 'Preview hunk' },
            R = { 'Reset buffer' },
            r = { 'Reset hunk' },
            s = { 'Stage hunk' },
            S = { 'Stage buffer' },
            u = { 'Undo stage hunk' },
            U = { 'Reset buffer index' },
          },
        }, { prefix = '<leader>' })
        wk.register { [']c'] = { 'Next hunk' }, ['[c'] = { 'Prev hunk' } }
      end,
      config = function()
        require('gitsigns').setup {
          signs = {
            add = { hl = 'GreenSign', text = '┃', numhl = 'GitSignsAddNr' },
            change = { hl = 'YellowSign', text = '┇', numhl = 'GitSignsChangeNr' },
            delete = { hl = 'RedSign', text = '┻', numhl = 'GitSignsDeleteNr' },
            topdelete = { hl = 'RedSign', text = '┳', numhl = 'GitSignsDeleteNr' },
            changedelete = {
              hl = 'PurpleSign',
              text = '│',
              numhl = 'GitSignsChangeNr',
            },
          },
        }
      end,
    }
    -- }}}

    -- FIX: Currently there is a missing font item in reactions on comments <12-12-21, kunzaatko> --
    -- 'pwntester/octo.nvim' -- github nvim UI {{{
    use {
      'pwntester/octo.nvim',
      setup = function()
        local wk = require 'which-key'
        wk.register({
          o = {
            name = 'Octo',
            i = {
              name = 'Issue',
              l = { 'List' },
              c = { 'Create' },
            },
            r = {
              name = 'Repo',
              l = {
                'List',
              },
            },
            p = {
              name = 'PullRequest',
              l = { 'List' },
              c = { 'Create' },
            },
          },
        }, { prefix = '<leader>' })
      end,
      config = function()
        vim.cmd [[packadd telescope.nvim]]
        require('octo').setup {
          default_remote = { 'upstream', 'origin', 'github' },
          reaction_viewer_hint_icon = '',
          user_icon = ' ',
          timeline_marker = ' ',
        }
        vim.api.nvim_set_keymap('n', '<leader>oil', '<Cmd>Octo issue list<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<leader>oic', '<Cmd>Octo issue create<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<leader>orl', '<Cmd>Octo repo list<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<leader>opl', '<Cmd>Octo pr list<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<leader>opc', '<Cmd>Octo pr create<CR>', { noremap = true, silent = true })
      end,
      requires = { 'nvim-telescope/telescope.nvim', 'kyazdani42/nvim-web-devicons' },
    }
    -- }}}

    -- }}}

    -- TERMINAL {{{
    -- TODO: Make Julia persistent REPL implementation <16-01-22, kunzaatko> --
    -- akinsho/toggleterm.nvim -- toggle the terminal but persist the session{{{
    use {
      'akinsho/toggleterm.nvim',
      keys = { '<C-p>' },
      config = function()
        _G.MUtils = _G.MUtils or {}
        local wk = require 'which-key'
        wk.register({
          ['<C-p>'] = { 'Toggle toggleterm' },
        }, {})

        _G.MUtils.set_terminal_keymaps = function()
          vim.api.nvim_buf_set_keymap(0, 't', '<C-w>', [[<C-\><C-n><C-W><C-W>]], { noremap = true })
        end

        vim.cmd [[autocmd! TermOpen term://* lua vim.opt_local.spell = false]]
        vim.cmd [[autocmd! TermOpen term://* lua _G.MUtils.set_terminal_keymaps()]]

        require('toggleterm').setup {
          size = function(term)
            if term.direction == 'horizontal' then
              return 15
            elseif term.direction == 'vertical' then
              return vim.o.columns * 0.4
            end
          end,
          open_mapping = '<C-p>',
          hide_numbers = true, -- hide the number column in toggleterm buffers
          shade_filetypes = {},
          shade_terminals = true,
          shading_factor = 1, -- darken terminal colour degree, default: 1 for dark backgrounds, 3 for light
          start_in_insert = true,
          insert_mappings = true, -- whether or not the open mapping applies in insert mode
          persist_size = true,
          direction = 'vertical',
          close_on_exit = true, -- close the terminal window when the process exits
          shell = 'fish',
        }
      end,
    }
    -- }}}
    -- }}}

    -- LIBRARIES {{{
    -- NOTE: Used for starting the watch daemon for figures <kunzaatko> --
    use { 'nvim-lua/plenary.nvim', ft = 'tex' }
    -- }}}

    -- OTHER {{{
    -- TODO: Close with `q` <16-01-22, kunzaatko> --
    -- 'dstein64/vim-startuptime' -- profiling for start-up time and plug-in loading {{{
    use {
      'dstein64/vim-startuptime',
      cmd = 'StartupTime',
      setup = 'vim.g.startuptime_tries = 10',
    }
    -- }}}

    -- TODO: Setup <16-01-22, kunzaatko> --
    -- 'glacambre/firenvim' -- extension for browser insert boxes to use nvim {{{
    use {
      'glacambre/firenvim',
      opt = true,
      run = function()
        vim.fn['firenvim#install'](0)
      end,
      cond = function()
        return vim.fn.exists 'g:started_by_firenvim'
      end,
    }
    -- }}}

    -- TODO: Is this fixed? <16-01-22, kunzaatko> --
    -- bug in neovim - https://github.com/neovim/neovim/issues/12587
    use 'antoinemadec/FixCursorHold.nvim'

    -- speeds-up the start-up time by using a lua version of the filetype.vim script
    use 'nathom/filetype.nvim'
    -- }}}

    -- NEORG {{{
    -- TODO: Setup <16-01-22, kunzaatko> --
    -- 'vhyrro/neorg' -- main package for norg format {{{
    use {
      'vhyrro/neorg',
      branch = 'main',
      config = function()
        require 'conf.pkgs.neorg'
      end,
    }
    -- }}}
    -- }}}
  end,
  config = {
    disable_commands = true, -- disable creating commands (created manually)
    profile = { enable = true },
  },
}
