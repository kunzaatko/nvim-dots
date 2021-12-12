local packer = require 'packer'
return packer.startup {
  function()
    local use = packer.use

    -- package management --

    use {'wbthomason/packer.nvim', opt = true} -- manage packer as optional plug-in

    -- LANGUAGES {{{
    -- FIX: There is a bug that causes this to give errors when it is an opt plug-in on several events <17-11-21, kunzaatko> --
    -- use {'JuliaEditorSupport/julia-vim', as = 'julia'} -- mainly for LaTeX to Unicode support

    -- 'rust-lang/rust.vim' -- Playpen integration, :RunTest{{{
    use {
      'rust-lang/rust.vim',
      as = 'rust',
      ft = 'rust',
      config = function()
        vim.g.rustfmt_autosave = 1
      end,
    } -- Playpen integration, :RunTest
    -- }}}

    -- 'simrat39/rust-tools.nvim' -- LSP rust specifics{{{
    use {
      'simrat39/rust-tools.nvim',
      ft = 'rust',
      config = function()
        require'rust-tools'.setup()
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

    use {'kovetskiy/sxhkd-vim', as = 'sxhkd', ft = 'sxhkd'} -- SXHKD spec file support
    use {'cespare/vim-toml', as = 'toml', ft = 'toml'} -- TOML language support
    use {'blankname/vim-fish', as = 'fish', ft = 'fish'} -- fish scripts support
    -- }}}

    -- COMPLETION AND LINTING {{{
    -- 'folke/trouble.nvim' -- diagnostics and quickfix-list {{{
    use {
      'folke/trouble.nvim',
      requires = 'kyazdani42/nvim-web-devicons',
      cmd = {'Trouble', 'TroubleToggle', 'TroubleClose', 'TroubleRefresh'},
      keys = {'<leader>tt', '<leader>tl', '<leader>tr', '<leader>td'},
      config = function()
        vim.api.nvim_set_keymap('n', '<Leader>tt', '<Cmd>TroubleToggle<CR>',
                                {noremap = true, silent = true}) -- Trouble 'global' (full workspace diagnostics)
        vim.api.nvim_set_keymap('n', '<Leader>tl',
                                '<Cmd>TroubleToggle lsp_document_diagnostics<CR>',
                                {noremap = true, silent = true}) -- Trouble 'local' (only the current buffer)
        vim.api.nvim_set_keymap('n', '<Leader>tr',
                                '<Cmd>TroubleToggle lsp_references<CR>',
                                {noremap = true, silent = true}) -- Trouble references
        vim.api.nvim_set_keymap('n', '<Leader>td',
                                '<Cmd>TroubleToggle lsp_definitions<CR>',
                                {noremap = true, silent = true}) -- Trouble definitions
      end,
    }
    -- }}}

    -- 'hrsh7th/nvim-cmp' -- completion engine {{{
    use {
      'hrsh7th/nvim-cmp',
      as = 'cmp',
      requires = {
        {'hrsh7th/cmp-buffer', after = 'cmp'},
        {'hrsh7th/cmp-path', after = 'cmp'},
        {'hrsh7th/cmp-cmdline', after = 'cmp'},
        {'quangnguyen30192/cmp-nvim-ultisnips', after = 'cmp'},
        {'petertriho/cmp-git', requires = 'nvim-lua/plenary.nvim'},
        'kdheepak/cmp-latex-symbols',
        'lukas-reineke/cmp-rg',
        'hrsh7th/cmp-nvim-lsp',
        'neovim/nvim-lspconfig',
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

    use {'nvim-treesitter/nvim-treesitter-textobjects', requires = 'nvim-treesitter'}

    -- 'nvim-treesitter/playground' -- see the treesitter tree live {{{
    use {
      'nvim-treesitter/playground',
      cmd = {':TSHighlightCapturesUnderCursor', ':TSPlaygroundToggle'},
      requires = {'nvim-treesitter'},
    }
    -- }}}

    -- 'nvim-lua/lsp_extensions' -- rust type annotations {{{
    use {
      'nvim-lua/lsp_extensions.nvim',
      ft = 'rust',
      config = function()
        require'lsp_extensions'.inlay_hints()
        vim.cmd [[
                augroup RustTypeHints
                    autocmd!
                    autocmd InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *.rs :lua require'lsp_extensions'.inlay_hints{ prefix = ' » ', highlight = "NonText", enabled = {"ChainingHint"} }
                augroup END
        ]]
      end,
    }
    -- }}}

    use {'folke/lua-dev.nvim', as = 'lua-dev'} -- development environment for lua and nvim

    -- }}}

    -- PRETTIFYING {{{
    -- 'mhartington/formatter.nvim' -- code formatting {{{
    use {
      'mhartington/formatter.nvim',
      ft = {
        'rust',
        'javascript',
        'json',
        'html',
        'python',
        'tex',
        'c',
        'cpp',
        'lua',
        'yaml',
        'css',
        'markdown',
        'toml',
        'sh',
        'bash',
      },
      config = function()
        require 'conf.pkgs.formatter'
        vim.api.nvim_set_keymap('n', '<leader>f', '<Cmd>Format<CR>', {silent = true})
      end,
    }
    -- }}}

    -- TODO: Do this using 'mhartington/formatter.nvim' <17-11-21, kunzaatko> --
    -- 'kdheepak/JuliaFormatter.vim' -- julia code formatting {{{
    use {
      'kdheepak/JuliaFormatter.vim',
      ft = 'julia',
      keys = '<leader>f',
      config = function()
        vim.g.JuliaFormatter_options = {['style'] = 'blue'}
        vim.api.nvim_set_keymap('n', '<leader>f', '<Cmd>JuliaFormatterFormat<CR>',
                                {silent = true})
      end,
    }
    -- }}}

    -- 'norcalli/nvim-colorizer.lua' -- colours visualizer {{{
    use {
      'norcalli/nvim-colorizer.lua',
      ft = {'css', 'javascript', 'vim', 'html', 'lua', 'tex'},
      config = function()
        require'colorizer'.setup({
          'css',
          'javascript',
          'html',
          'tex',
          vim = {names = false, hsl_fn = true},
          lua = {names = false, hsl_fn = true},
        }, {mode = 'foreground'})
      end,
    }
    -- }}}

    use {'godlygeek/tabular', cmd = 'Tabularize'} -- tabularizing on a search pattern
    -- }}}

    -- SESSIONS AND CONVENIENCES {{{
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
      end,
      config = function()
        vim.api.nvim_set_keymap('n', '<leader>u', '<Cmd>UndotreeToggle<CR>',
                                {noremap = true, silent = true})
      end,

    } -- }}}

    -- 'folke/which-key.nvim' -- echo keymappings {{{
    use {
      'folke/which-key.nvim',
      config = function()
        -- TODO: configure https://github.com/folke/which-key.nvim <28-04-21, kunzaatko> --
        require'which-key'.setup {}
      end,
    }
    -- }}}

    -- }}}

    -- AESTHETICS {{{
    -- 'glepnir/galaxyline.nvim' -- status line{{{
    use {
      'glepnir/galaxyline.nvim',
      config = function()
        require 'conf.pkgs.galaxyline'
      end,
      requires = {'kyazdani42/nvim-web-devicons', 'rktjmp/lush.nvim'},
    }
    -- }}}

    -- 'folke/zen-mode.nvim' --  focus mode{{{
    use {
      'folke/zen-mode.nvim',
      cmd = {'ZenMode'},
      keys = '<leader>z',
      config = function()
        require("zen-mode").setup {
          -- TODO: configure https://github.com/folke/zen-mode.nvim <26-07-21, kunzaatko> --
        }
        vim.api.nvim_set_keymap('n', '<leader>z', '<Cmd>ZenMode<CR>',
                                {noremap = true, silent = true})
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
        vim.g.indent_blankline_filetype_exclude = {'help', 'markdown', 'txt'}
        vim.g.indent_blankline_buftype_exclude = {'terminal'}
        vim.g.indent_blankline_space_char = '·'
        vim.opt.colorcolumn = "999999" -- fix: for https://github.com/lukas-reineke/indent-blankline.nvim/issues/59
      end,
    }
    -- }}}

    -- 'folke/todo-comments.nvim' -- todo comments and todo quickfix-list {{{
    use {
      'folke/todo-comments.nvim',
      requires = "nvim-lua/plenary.nvim",
      config = function()
        require("todo-comments").setup {highlight = {keyword = "fg", after = ""}}
        -- TODO: configure https://github.com/folke/todo-comments.nvim <26-07-21, kunzaatko> --
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

    use 'romainl/vim-cool' -- disable search highlight when done with searching

    ----------------------
    --  colour-schemes  --
    ----------------------
    -- 'npxbr/gruvbox.nvim' -- colour-scheme {{{
    use {
      'npxbr/gruvbox.nvim',
      requires = {'rktjmp/lush.nvim'},
      config = function()
        vim.cmd('colorscheme gruvbox')
      end,
      after = {'lush.nvim'},
      cond = 'false',
    }
    -- }}}

    -- 'kunzaatko/nord.nvim' -- colour-scheme {{{
    use {
      '~/.config/nvim/pack/opt/nord-vim',
      requires = {'rktjmp/lush.nvim', opt = true},
      setup = function()
        vim.g.nord_italic = 1
        vim.g.nord_italic_comments = 1
        vim.g.nord_underline = 1
      end,
      config = function()
        vim.cmd('colorscheme nord')
      end,
    }
    -- }}}
    -- }}}

    -- MOVEMENT {{{

    -- 'ggandor/lightspeed.nvim' -- enhanced f,F,t,T and s,S for double letter searching {{{
    use {
      'ggandor/lightspeed.nvim',
      keys = {'s', 'S', 'f', 'F', 't', 'T'},
      requires = 'tpope/vim-repeat',
    }
    -- }}}

    -- 'karb94/neoscroll.nvim' -- for smooth scrolling {{{
    use {
      'karb94/neoscroll.nvim',
      config = function()
        require'neoscroll'.setup()
      end,
    }
    -- }}}

    -- 'nvim-telescope/telescope.nvim' -- file finder and list shower {{{
    use {
      'nvim-telescope/telescope.nvim',
      keys = {
        '<leader><leader>f',
        '<leader><leader>g',
        '<leader><leader>b',
        '<leader><leader>h',
      },
      cmd = 'Telescope',
      requires = {
        'nvim-lua/plenary.nvim',
        {'nvim-telescope/telescope-fzf-native.nvim', run = 'make'},
        'nvim-treesitter/nvim-treesitter',
      },
      config = function()
        vim.cmd [[packadd trouble.nvim]]
        local trouble = require("trouble.providers.telescope")
        require'telescope'.setup({
          defaults = {
            mappings = {
              i = {["<C-q>"] = trouble.open_with_trouble},
              n = {["<C-q>"] = trouble.open_with_trouble},
            },
          },
        })
        require'telescope'.load_extension('fzf')

        if packer_plugins.notify.loaded == true then
          -- TODO: Defer the loading of this extension when notify is loaded <03-12-21, kunzaatko> --
          require('telescope').load_extension('notify')
        end

        vim.api.nvim_set_keymap('n', '<leader><leader>f',
                                "<Cmd>lua require'telescope.builtin'.git_files()<CR>",
                                {noremap = true, silent = true})
        vim.api.nvim_set_keymap('n', '<leader><leader>g',
                                "<Cmd>lua require'telescope.builtin'.live_grep()<CR>",
                                {noremap = true, silent = true})
        vim.api.nvim_set_keymap('n', '<leader><leader>b',
                                "<Cmd>lua require'telescope.builtin'.buffers()<CR>",
                                {noremap = true, silent = true})
        vim.api.nvim_set_keymap('n', '<leader><leader>h',
                                "<Cmd>lua require'telescope.builtin'.help_tags()<CR>",
                                {noremap = true, silent = true})
      end,
    }

    -- }}}

    -- }}}

    -- TEXT-EDITING FEATURES {{{

    -- 'windwp/nvim-autopairs' -- automatically adding matching delimiters {{{
    use {
      'windwp/nvim-autopairs',
      event = 'InsertEnter',
      config = function()
        require'nvim-autopairs'.setup()
      end,
    } -- }}}

    -- 'blackCauldron7/surround.nvim' -- text objects and editing surrounding delimiters{{{
    use {
      'blackCauldron7/surround.nvim',
      config = function()
        require'surround'.setup {mappings_style = 'surround'}
      end,
    } -- }}}

    -- 'b3nj5m1n/kommentary' -- commenting {{{
    use {
      'b3nj5m1n/kommentary',
      config = function()
        require'kommentary.config'.configure_language("default", {
          prefer_single_line_comments = true,
        })
      end,
    }
    -- }}}

    use 'tpope/vim-abolish' -- abbreviations
    -- }}}

    -- SNIPPETS {{{
    -- 'sirver/ultisnips' -- snippets {{{
    use {
      'sirver/ultisnips',
      event = 'InsertEnter',
      setup = function()
        -- Snippets variables
        vim.g.snips_author = "kunzaatko"
        vim.g.snips_email = "martinkunz@email.cz"
        vim.g.snips_github = "https://github.com/kunzaatko"
        -- UltiSnips
        vim.opt.runtimepath = vim.opt.runtimepath + {vim.fn.expand("$PWD")}
        vim.g.UltiSnipsSnippetDirectories = {'snips'} -- this ensures that snippets directories are not recursively searched
        vim.g.UltiSnipsEnableSnipMate = 0 -- only look for UltiSnips snippets
        vim.g.UltiSnipsExpandTrigger = '<Plug>(ultisnips_expand)'
        vim.g.UltiSnipsJumpForwardTrigger = '<Plug>(ultisnips_jump_forward)'
        vim.g.UltiSnipsJumpBackwardTrigger = '<Plug>(ultisnips_jump_backward)'
        vim.g.UltiSnipsRemoveSelectModeMappings = 0 -- for using tab in nvim-cmp
      end,
      config = function()
        if vim.bo.filetype == 'tex' then
          vim.g.UltiSnipsSnippetStorageDirectoryForUltiSnipsEdit =
            TEXUtils.get_tex_root():joinpath("snips").filename
        end
        vim.api.nvim_set_keymap('x', '<C-l>',
                                ':lua vim.call("UltiSnips#SaveLastVisualSelection")<CR>gvs',
                                {noremap = true, silent = true})
        vim.api.nvim_set_keymap('s', '<C-l>',
                                ':lua vim.call("UltiSnips#ExpandSnippet")<CR>',
                                {noremap = true, silent = true})
      end,
    } -- }}}
    -- }}}

    -- GIT {{{
    -- 'TimUntersberger/neogit' -- magit for neovim {{{
    use {
      'TimUntersberger/neogit',
      cmd = 'Neogit',
      keys = '<leader>g',
      requires = 'sindrets/diffview.nvim',
      config = function()
        require'neogit'.setup({
          disable_hint = true,
          disable_builtin_notifications = true,
          disable_commit_confirmation = true,
          commit_popup = {kind = "vsplit"},
          integrations = {diffview = true},
        })
        vim.api.nvim_set_keymap('n', '<leader>g',
                                "<Cmd> lua require'neogit'.open()<CR>",
                                {noremap = true, silent = true})
      end,
    }
    -- }}}

    -- 'lewis6991/gitsigns.nvim' -- signs of changes in sign column {{{
    use {
      'lewis6991/gitsigns.nvim',
      requires = 'nvim-lua/plenary.nvim',
      setup = function()
        vim.cmd "packadd plenary.nvim"
      end,
      config = function()
        require'gitsigns'.setup {
          signs = {
            add = {hl = 'GreenSign', text = '│', numhl = 'GitSignsAddNr'},
            change = {hl = 'BlueSign', text = '│', numhl = 'GitSignsChangeNr'},
            delete = {hl = 'RedSign', text = '│', numhl = 'GitSignsDeleteNr'},
            topdelete = {hl = 'RedSign', text = '│', numhl = 'GitSignsDeleteNr'},
            changedelete = {hl = 'PurpleSign', text = '│', numhl = 'GitSignsChangeNr'},
          },
        }
      end,
    }
    -- }}}
    -- }}}

    -- LIBRARIES {{{
    -- NOTE: Used for starting the watch daemon for figures <kunzaatko> --
    use {'nvim-lua/plenary.nvim', ft = 'tex'}
    -- }}}

    -- OTHER {{{
    use {
      'dstein64/vim-startuptime',
      cmd = 'StartupTime',
      setup = 'vim.g.startuptime_tries = 10',
      config = function()
        vim.cmd [[autocmd FileType startuptime lua vim.opt_local.spell = false]]
      end,
    } -- profiling

    use {
      'glacambre/firenvim',
      opt = true,
      run = function()
        vim.fn['firenvim#install'](0)
      end,
      cond = function()
        return vim.fn.exists('g:started_by_firenvim')
      end,
    } -- extension for browser insert boxes to use nvim

    use 'antoinemadec/FixCursorHold.nvim' -- bug in neovim - https://github.com/neovim/neovim/issues/12587

    use 'nathom/filetype.nvim' -- speedsup the startuptime by using a lua version of the filetype.vim script
    -- }}}

  end,
  config = {disable_commands = true, profile = {enable = true}}, -- disable creating commands (created manually)
}
