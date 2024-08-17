local M = {
  {
    'neovim/nvim-lspconfig',
    name = 'lspconfig',
    event = 'BufReadPre',
    dependencies = {
      { 'folke/neodev.nvim', config = true, name = 'neodev' },
      'mason',
      { 'williamboman/mason-lspconfig.nvim', name = 'mason-lspconfig' },
      'hrsh7th/cmp-nvim-lsp',
    },
    opts = {
      servers = {
        jsonls = {},
        kotlin_language_server = {},
        taplo = {},
        html = { filetypes = { 'html', 'htmldjango' } },
        texlab = {
          settings = {
            texlab = {
              bibtexFormatter = 'texlab',
              build = {
                auxDirectory = '.', -- FIX: This is not correct. Should be the build root directory <26-12-23>
                args = {
                  '-X',
                  'compile',
                  '%f',
                  '--synctex',
                  '--keep-logs',
                  '--keep-intermediates',
                },
                executable = 'tectonic',
                onSave = false,
              },
              chktex = {
                onEdit = false,
                onOpenAndSave = false,
              },
              diagnosticsDelay = 300,
              formatterLineLength = 120,
              forwardSearch = {
                executable = 'zathura',
                args = { '--synctex-forward', '%l:1:%f', '%p' },
              },
              latexFormatter = 'latexindent',
              latexindent = {
                modifyLineBreaks = false,
              },
            },
          },
        },
        -- FIX: Java environment is not compatible with `ltex` <08-08-24>
        -- ltex = {
        --   settings = {
        --     ltex = {
        --       language = 'en-GB',
        --     },
        --   },
        -- },
        bashls = {},
        ccls = {},
        vimls = {},
        julials = {
          cmd = {
            'env',
            'LD_LIBRARY_PATH=/usr/lib/julia',
            'julia',
            '--startup-file=no',
            '--history-file=no',
            '-e',
            [[
              ls_install_path = joinpath(get(DEPOT_PATH, 1, joinpath(homedir(), ".julia")), "environments", "nvim-lspconfig")
              pushfirst!(LOAD_PATH, ls_install_path)
              using LanguageServer
              popfirst!(LOAD_PATH)
              depot_path = get(ENV, "JULIA_DEPOT_PATH", "")
              project_path = let 
                dirname(something(Base.load_path_expand((p = get(ENV, "JULIA_PROJECT", nothing);
                p === nothing ? nothing : isempty(p) ? nothing : p)),
                Base.current_project(),
                get(Base.load_path(), 1, nothing),
                Base.load_path_expand("@v#.#"),))
              end
              @info "Running language server" VERSION pwd() project_path depot_path
              server = LanguageServer.LanguageServerInstance(stdin, stdout, project_path, depot_path)
              server.runlinter = true
              run(server)
            ]],
          },
        },
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = 'off',
              },
            },
          },
        },
        lua_ls = {
          settings = {
            Lua = {
              runtime = {
                version = 'LuaJIT',
              },
              diagnostics = {
                globals = { 'vim' },
              },
              workspace = {
                library = vim.api.nvim_get_runtime_file('', true),
                checkThirdParty = false,
              },
              completion = {
                callSnippet = 'Replace',
              },
            },
          },
        },
        harper_ls = {
          filetypes = { 'markdown', 'latex', 'tex', 'txt', 'html' },
          settings = {
            ['harper-ls'] = {
              linters = {
                spell_check = false,
                -- wrong_quotes = true,
              },
            },
          },
        },
        tinymist = {
          -- TODO: these configuration from lspconfig maybe broken
          single_file_support = true,
          root_dir = function()
            return vim.fn.getcwd()
          end,
          -- See [Tinymist Server Configuration](https://github.com/Myriad-Dreamin/tinymist/blob/main/Configuration.md) for references.
          settings = {
            exportPdf = 'onType',
            formatterMode = 'typstyle',
          },
        },
      },
    },
    config = function(_, opts)
      vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = 'rounded',
      })

      vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = 'rounded',
      })
      require('util').lsp.on_attach(function(client, buffer)
        require('plugins.lsp.format').on_attach(client, buffer)
        require('plugins.lsp.keymaps').on_attach(client, buffer)
      end)

      local capabilities = require('cmp_nvim_lsp').default_capabilities(require('util.lsp').capabilities)
      require('mason-lspconfig').setup_handlers {
        function(server)
          local server_opts = opts.servers[server] or {}
          server_opts.capabilities = capabilities
          require('lspconfig')[server].setup(server_opts)
        end,
      }
      opts.servers.texlab.capabilities = capabilities
      require('lspconfig').texlab.setup(opts.servers.texlab)
      -- require('lspconfig').ltex.setup(opts.servers.ltex) -- FIX: not working with current Java installation
      -- FIX: For some reason this server is not configured. My hypothesis is that it does not get configured due to it
      -- not being installed by Mason... This explicit setting up solves it <25-04-24>
      require('lspconfig').ccls.setup(opts.servers.ccls)
    end,
  },
  {
    'williamboman/mason.nvim',
    name = 'mason',
    cmd = 'Mason',
    opts = {
      ensure_installed = {
        'stylua',
        'yapf',
        'shellcheck',
        'shfmt',
        'flake8',
        'clang-format',
        'proselint',
        'misspell',
      },
    },
    ---@param opts MasonSettings | {ensure_installed: string[]}
    config = function(_, opts)
      require('mason').setup(opts)
      local mr = require 'mason-registry'
      for _, tool in ipairs(opts.ensure_installed) do
        local p = mr.get_package(tool)
        if not p:is_installed() then
          p:install()
        end
      end
    end,
  },
  -- TODO: Use the noice.nvim interface for renaming <11-05-23>
  { 'smjonas/inc-rename.nvim', opts = { input_buffer_type = 'dressing' }, event = 'VeryLazy', cmd = 'IncRename' },
  {
    'aznhe21/actions-preview.nvim',
    event = 'VeryLazy',
    opts = {
      diff = {
        algorithm = 'patience',
        ignore_whitespace = true,
      },
      telescope = require('telescope.themes').get_dropdown { winblend = 10 },
    },
  },
  {
    'ray-x/lsp_signature.nvim',
    name = 'lsp-signature',
    event = 'InsertEnter',
    opts = {
      hint_enable = false,
      transparency = 10,
    },
  },
}

return M
