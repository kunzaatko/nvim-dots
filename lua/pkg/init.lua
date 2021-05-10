local packer = require 'packer'
return packer.startup {
  function()
    local use = packer.use

    -- package management --

    use {'wbthomason/packer.nvim', opt = true} -- manage packer as optional plug-in

    --  languages  --

    use {
      'JuliaEditorSupport/julia-vim',
      config = function()
        require 'conf.pkgs.julia'
      end,
    }
    use {
      'rust-lang/rust.vim',
      config = function()
        require 'conf.pkgs.rust'
      end,
    }
    use {
      'lervag/vimtex',
      config = function()
        require 'conf.pkgs.vimtex'
      end,
    }
    use 'kovetskiy/sxhkd-vim'
    use 'cespare/vim-toml'
    use 'blankname/vim-fish'

    --  completion and linting  --

    use {
      'neovim/nvim-lspconfig',
      config = function()
        require 'conf.pkgs.lsp-config'
      end,
    } -- default configuration for lsp servers
    use {
      'nvim-lua/completion-nvim',
      event = 'InsertEnter', -- already implied by loading after nvim-autopairs
      after = {'nvim-autopairs'}, -- TODO: Why does it have to be here? In the help of completion-nvim, there is that it can be used without nvim-lspconfig <06-03-21, kunzaatko> --
      config = function()
        require 'conf.pkgs.completion-nvim'
      end,
    } -- enable lsp and other sources into omnicomp
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

    --  prettyfying --

    use {
      'mhartington/formatter.nvim',
      config = function()
        require 'conf.pkgs.formatter'
      end,
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
        'json',
      },
    } -- code formatting
    use {
      'kdheepak/JuliaFormatter.vim',
      ft = {'julia'},
      config = function()
        require 'conf.pkgs.JuliaFormatter'
      end,
    } -- julia code formatting
    use {'godlygeek/tabular', cmd = 'Tabularize'} -- tabularizing on a search pattern
    use {
      'norcalli/nvim-colorizer.lua',
      ft = {'css', 'javascript', 'vim', 'html', 'lua'},
      config = function()
        require'colorizer'.setup({
          'css',
          'javascript',
          'html',
          vim = {names = false, hsl_fn = true},
          lua = {names = false, hsl_fn = true},
        }, {mode = 'foreground'})
      end,
    } -- colors visualizer

    -- sessions and conviniences --

    use {
      'mhinz/vim-startify',
      config = function()
        vim.g.startify_fortune_use_unicode = 1
      end,
    } -- launch page
    use {
      'mbbill/undotree',
      cmd = 'UndotreeToggle',
      config = function()
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

    --  aesthetics  --

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
        vim.cmd("colorscheme gruvbox")
      end,
      after = {'lush.nvim'},
      cond = 'false',
    } -- colorscheme
    use {
      '~/.config/nvim/pack/opt/nord-vim',
      requires = {'rktjmp/lush.nvim', opt = true},
      config = function()
        vim.g.nord_italic = 1
        vim.g.nord_italic_comments = 1
        vim.g.nord_underline = 1
        vim.cmd("colorscheme nord")
      end,
      after = {'lush.nvim'},
      cond = 'true',
    } -- colorscheme
    use {
      'kdav5758/TrueZen.nvim',
      cmd = {'TZMinimalist', 'TZFocus', 'TZAtaraxis', 'TZBottom', 'TZTop', 'TZLeft'},
      config = function()
        -- vim.api.nvim_set_keymap("n", "<F12>", [[<Cmd>TZAtaraxis<CR>]]) -- todo
      end,
    } -- focus mode
    use {
      'lukas-reineke/indent-blankline.nvim',
      branch = 'lua',
      config = function()
        vim.g.indent_blankline_char = '│'
        vim.g.indent_blankline_use_treesitter = true
        vim.g.indent_blankline_show_first_indent_level = false
        vim.g.indent_blankline_filetype_exclude = {'help', 'markdown', 'txt'}
        vim.g.indent_blankline_buftype_exclude = {'terminal'}
        -- vim.g.indent_blankline_context_highlight_list = true
        -- vim.g.indent_blankline_bufname_exclude = {''}
        -- vim.g.indent_blankline_space_char = '·'
      end,
    } -- indentation characters

    --  movement  --

    use { -- TODO: Add mappings - it a long loading mapping
      'easymotion/vim-easymotion',
      config = function()
        require 'conf.pkgs.easymotion'
      end,
    } -- enhanced f/F/t/T
    use {
      'yuttie/comfortable-motion.vim',
      config = function()
        require 'conf.pkgs.comfortable-motion'
      end,
    } -- for smooth scrolling
    -- use 'chaoren/vim-wordmotion' -- CamelCase word object definition FIXME: can I live without this plugin?
    use {
      'tpope/vim-surround',
      requires = {'tpope/vim-repeat'}, -- repeat needed for dot command
    } -- text objects and editing surrounding delimiters

    --  text-editing features  --

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

    --  snippets  --

    use {
      'sirver/ultisnips',
      config = function()
        require 'conf.pkgs.ultisnips'
      end,
    }
    use {
      'honza/vim-snippets',
      opt = true, -- only using packer for updating the repo
    }

    --  git --

    use {'tpope/vim-fugitive', cmd = {'G', 'Gblame', 'Gpush', 'Gpull'}}
    use {
      'lewis6991/gitsigns.nvim',
      requires = {'nvim-lua/plenary.nvim'},
      config = function()
        require 'conf.pkgs.gitsigns'
      end,
    }

    --  other --

    use {
      'dstein64/vim-startuptime',
      cmd = 'StartupTime',
      config = [[vim.g.startuptime_tries = 10]],
    } -- profiling
    use 'antoinemadec/FixCursorHold.nvim' -- bug in neovim - https://github.com/neovim/neovim/issues/12587

  end,
  config = {disable_commands = true}, -- disable creating commands (created manually)
}
