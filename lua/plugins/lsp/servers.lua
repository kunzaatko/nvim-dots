local M = {
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
}

return M
