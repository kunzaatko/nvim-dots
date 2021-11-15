local packer = require 'packer'
return packer.startup {
  function()
    local use = packer.use

    -- package management --

    use {'wbthomason/packer.nvim', opt = true} -- manage packer as optional plug-in

    -- languages {{{
    use {'JuliaEditorSupport/julia-vim'}

    use {
      'rust-lang/rust.vim',
      ft = {"rust"},
      config = function()
        vim.g.rustfmt_autosave = 1
      end,
    }

    use {
      'lervag/vimtex',
      ft = "tex",
      setup = function()
        require 'conf.pkgs.vimtex'
      end,
    }

    use {'kovetskiy/sxhkd-vim', ft = {"sxhkd"}}
    use {'cespare/vim-toml', ft = {"toml"}}
    use {'blankname/vim-fish', ft = {"fish"}}
    -- }}}

    -- completion and linting {{{
    use {
      'neovim/nvim-lspconfig',
      config = function()
        require 'conf.pkgs.lsp-config'
      end,
    } -- default configuration for lsp servers

    use {
      'folke/trouble.nvim',
      cmd = {'Trouble', 'TroubleClose', 'TroubleToggle', 'TroubleRefresh'},
      requires = 'kyazdani42/nvim-web-devicons',
      config = function()
        require'trouble'.setup {
          -- TODO: configure https://github.com/folke/trouble.nvim <26-07-21, kunzaatko> --
        }
      end,
    } -- diagnostics and quickfixlist

    -- FIX: This plugin is not maintained anymore <09-11-21, kunzaatko> --
    use {
      'nvim-lua/completion-nvim',
      event = 'InsertEnter', -- already implied by loading after nvim-autopairs
      after = {'nvim-autopairs'}, -- TODO: Why does it have to be here? In the help of completion-nvim, there is that it can be used without nvim-lspconfig <06-03-21, kunzaatko> --
      config = function()
        require 'conf.pkgs.completion-nvim'
      end,
    } -- enable lsp and inserts other sources into omnicomplete

    use {
      'nvim-treesitter/nvim-treesitter',
      requires = {
        'nvim-treesitter/nvim-treesitter-refactor',
        'nvim-treesitter/nvim-treesitter-textobjects',
      },
      config = function()
        require 'conf.pkgs.treesitter'
      end,
    }

    use {
      'nvim-lua/lsp_extensions.nvim',
      ft = {"rust"},
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

    use {'nvim-treesitter/completion-treesitter', after = 'completion-nvim'} -- TODO: setup in the completion-nvim config <10-05-21, kunzaatko> --
    -- }}}

    -- prettyfying {{{
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
      end,
    } -- code formatting

    use {
      'kdheepak/JuliaFormatter.vim',
      ft = {'julia'},
      config = function()
        require 'conf.pkgs.JuliaFormatter'
      end,
    } -- julia code formatting

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
    } -- colors visualizer

    use {'godlygeek/tabular', cmd = 'Tabularize'} -- tabularizing on a search pattern
    -- }}}

    -- sessions and conviniences {{{
    use {
      'mhinz/vim-startify',
      setup = function()
        vim.g.startify_fortune_use_unicode = 1
      end,
    } -- launch page

    use {
      'mbbill/undotree',
      cmd = 'UndotreeToggle',
      setup = function()
        require 'conf.pkgs.undotree'
      end,
    } -- undotree visualizer

    use {
      'folke/which-key.nvim',
      config = function()
        -- TODO: configure https://github.com/folke/which-key.nvim <28-04-21, kunzaatko> --
        require'which-key'.setup {}
      end,
    } -- keymappings echo

    use {
      'onsails/lspkind-nvim',
      config = function()
        require'lspkind'.init {with_text = false}
      end,
    }
    -- }}}

    -- aesthetics {{{
    use {
      'glepnir/galaxyline.nvim',
      config = function()
        require 'conf.pkgs.galaxyline'
      end,
      requires = {'kyazdani42/nvim-web-devicons', 'rktjmp/lush.nvim'},
    } -- status line

    use {
      'npxbr/gruvbox.nvim',
      requires = {'rktjmp/lush.nvim'},
      config = function()
        vim.cmd('colorscheme gruvbox')
      end,
      after = {'lush.nvim'},
      cond = 'false',
    } -- colorscheme

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
      after = {'lush.nvim'},
      cond = 'true',
    } -- colorscheme

    use {
      'folke/zen-mode.nvim',
      cmd = {'ZenMode'},
      config = function()
        require("zen-mode").setup {
          -- TODO: configure https://github.com/folke/zen-mode.nvim <26-07-21, kunzaatko> --
        }
      end,
    } -- focus mode

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
    } -- indentation characters

    use {
      "folke/todo-comments.nvim",
      requires = "nvim-lua/plenary.nvim",
      config = function()
        require("todo-comments").setup {highlight = {keyword = "fg", after = ""}}
        -- TODO: configure https://github.com/folke/todo-comments.nvim <26-07-21, kunzaatko> --
      end,
    } -- todo comments and todo quickfixlist

    use {"rcarriga/nvim-notify"}
    -- }}}

    -- movement {{{
    use { -- TODO: Add mappings - it a long loading mapping
      'easymotion/vim-easymotion',
      config = function()
        require 'conf.pkgs.easymotion'
      end,
    } -- enhanced f/F/t/T

    use {
      'yuttie/comfortable-motion.vim',
      setup = function()
        vim.g.comfortable_motion_friction = 70.0
        vim.g.comfortable_motion_air_drag = 3.0
      end,
      config = function()
        require 'conf.pkgs.comfortable-motion'
      end,
    } -- for smooth scrolling

    use {
      'blackCauldron7/surround.nvim',
      config = function()
        require'surround'.setup {mappings_style = 'surround'}
      end,
      requires = {'tpope/vim-repeat'}, -- repeat needed for dot command
    } -- text objects and editing surrounding delimiters

    use { -- TODO:  Configure. Add mapping <c-j> <c-k> for moving in entries. <19-05-21, kunzaatko> --
      'nvim-telescope/telescope.nvim',
      requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}},
    }
    -- }}}

    -- text-editing features {{{
    use {
      'windwp/nvim-autopairs',
      event = 'InsertEnter',
      config = function()
        require 'conf.pkgs.autopairs'
      end,
    } -- automatically adding matching delimiters

    use {
      'b3nj5m1n/kommentary',
      setup = function()
        vim.g.kommentary_create_default_mappings = false
      end,
      config = function()
        require 'conf.pkgs.kommentary'
      end,
    } -- commenting lua drop-in replacement for vim-commentary

    use 'tpope/vim-abolish' -- abbreviations
    use 'romainl/vim-cool' -- disable search highlight when done with searching
    -- }}}

    -- snippets {{{
    use {
      'sirver/ultisnips',
      event = 'InsertEnter',
      setup = function()
        require 'conf.pkgs.ultisnips'

      end,
      config = function()
        if vim.bo.filetype == 'tex' then
          vim.g.UltiSnipsSnippetStorageDirectoryForUltiSnipsEdit =
            TEXUtils.get_tex_root():joinpath("snips").filename
        end
      end,
    }

    -- }}}

    -- git {{{
    use {'tpope/vim-fugitive', cmd = {'G', 'Gblame', 'Gpush', 'Gpull', 'Gdiffsplit'}}

    use {
      'lewis6991/gitsigns.nvim',
      requires = 'nvim-lua/plenary.nvim',
      config = function()
        require('gitsigns').setup {
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

    -- libraries {{{
    -- NOTE: must be a start plugin because it is required by start package gitsigns <kunzaatko> --
    use 'nvim-lua/plenary.nvim'
    -- }}}

    -- other {{{
    use {
      'dstein64/vim-startuptime',
      cmd = 'StartupTime',
      setup = [[vim.g.startuptime_tries = 10]],
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
    } -- extention for browser insert boxes to use nvim

    use 'antoinemadec/FixCursorHold.nvim' -- bug in neovim - https://github.com/neovim/neovim/issues/12587

    use 'nathom/filetype.nvim' -- speedsup the startuptime by using a lua version of the filetype.vim script
    -- }}}

  end,
  config = {disable_commands = true}, -- disable creating commands (created manually)

}
