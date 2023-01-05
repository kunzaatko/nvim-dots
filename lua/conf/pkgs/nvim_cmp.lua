local lspconfig = require 'lspconfig'

require 'utils.lsputils'

-- Generic configuration for LSP servers, that do not require special handling
local status_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if not status_ok then
  return
end

local capabilities = cmp_nvim_lsp.default_capabilities(vim.lsp.protocol.make_client_capabilities())

local servers = { 'texlab', 'bashls', 'ccls', 'vimls' }
for _, server in pairs(servers) do
  lspconfig[server].setup {
    on_attach = _G.LSPUtils.on_attach,
    capabilities = capabilities,
  }
end

lspconfig.julials.setup {
  on_attach = _G.LSPUtils.on_attach,
  cmd = {
    'env',
    'LD_LIBRARY_PATH=/usr/lib/julia',
    'julia',
    '--startup-file=no',
    '--history-file=no',
    '-e',
    '    # Load LanguageServer.jl: attempt to load from ~/.julia/environments/nvim-lspconfig\n    # with the regular load path as a fallback\n    ls_install_path = joinpath(\n        get(DEPOT_PATH, 1, joinpath(homedir(), ".julia")),\n        "environments", "nvim-lspconfig"\n    )\n    pushfirst!(LOAD_PATH, ls_install_path)\n    using LanguageServer\n    popfirst!(LOAD_PATH)\n    depot_path = get(ENV, "JULIA_DEPOT_PATH", "")\n    project_path = let\n        dirname(something(\n            ## 1. Finds an explicitly set project (JULIA_PROJECT)\n            Base.load_path_expand((\n                p = get(ENV, "JULIA_PROJECT", nothing);\n                p === nothing ? nothing : isempty(p) ? nothing : p\n            )),\n            ## 2. Look for a Project.toml file in the current working directory,\n            ##    or parent directories, with $HOME as an upper boundary\n            Base.current_project(),\n            ## 3. First entry in the load path\n            get(Base.load_path(), 1, nothing),\n            ## 4. Fallback to default global environment,\n            ##    this is more or less unreachable\n            Base.load_path_expand("@v#.#"),\n        ))\n    end\n    @info "Running language server" VERSION pwd() project_path depot_path\n    server = LanguageServer.LanguageServerInstance(stdin, stdout, project_path, depot_path)\n    server.runlinter = true\n    run(server)\n  ',
  },
  capabilities = capabilities,
}

lspconfig.pyright.setup {
  on_attach = _G.LSPUtils.on_attach,
  capabilities = capabilities,
  settings = {
    python = {
      analysis = {
        typeCheckingMode = 'off',
      },
    },
  },
}

if packer_plugins['neodev'].loaded == true then
  require('neodev').setup {}

  lspconfig.sumneko_lua.setup {
    on_attach = function(client, bufnr)
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
      _G.LSPUtils.on_attach(client, bufnr)
    end,
    cmd = { 'lua-language-server' },
    settings = {
      Lua = {
        diagnostics = { globals = { 'packer_plugins', 'LSPUtils', 'MUtils' } },
        workspace = {
          preloadFileSize = 1000,
        },
      },
    },
  }
end

local cmp = require 'cmp'
local luasnip = require 'luasnip'

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match '%s' == nil
end

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

-- TODO: Add sources lazily with autocommands <20-08-22>
cmp.setup {
  experimental = {
    ghost_text = true,
  },
  -- NOTE: Generation of LSP snippets <kunzaatko> --
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<Tab>'] = cmp.mapping {
      c = function() -- command line mappings {{{
        if cmp.visible() then
          cmp.select_next_item { behavior = cmp.SelectBehavior.Insert }
        else
          cmp.complete()
        end
      end, -- }}}
      i = function(fallback) -- insert mode mappings {{{
        if cmp.visible() then -- select next
          cmp.select_next_item { behavior = cmp.SelectBehavior.Insert }
        elseif luasnip.expand_or_locally_jumpable() then -- luasnip
          luasnip.expand_or_jump()
        elseif packer_plugins.neogen.loaded and require('neogen').jumpable() then -- docs jump next
          vim.fn.feedkeys(t "<Cmd>lua require('neogen').jump_next()<CR>", '')
        elseif has_words_before() then -- cmp
          cmp.complete()
        else
          fallback()
        end
      end, -- }}}
      s = function(fallback) -- select mode mappings {{{
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_locally_jumpable() then
          luasnip.expand_or_jump()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, -- }}}
    },
    -- TODO: Add neogen mapping <12-03-22, kunzaatko> --
    ['<S-Tab>'] = cmp.mapping {
      c = function() -- command line mappings {{{
        if cmp.visible() then
          cmp.select_prev_item { behavior = cmp.SelectBehavior.Insert }
        else
          cmp.complete()
        end
      end, -- }}}
      i = function(fallback) -- insert mode mappings {{{
        if cmp.visible() then
          cmp.select_prev_item { behavior = cmp.SelectBehavior.Insert }
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, -- }}}
      s = function(fallback) -- select mode mappings {{{
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, -- }}}
    },
    ['<Down>'] = cmp.mapping(cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select }, { 'i' }),
    ['<Up>'] = cmp.mapping(cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select }, { 'i' }),
    ['<C-n>'] = cmp.mapping {
      c = function() -- command line mappings {{{
        if cmp.visible() then
          cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
        else
          vim.api.nvim_feedkeys(t '<Down>', 'n', true)
        end
      end, -- }}}
      i = function(fallback) -- insert mode mappings {{{
        if cmp.visible() then
          cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
        else
          fallback()
        end
      end, -- }}}
    },
    ['<C-p>'] = cmp.mapping {
      c = function() -- command line mappings {{{
        if cmp.visible() then
          cmp.select_prev_item { behavior = cmp.SelectBehavior.Select }
        else
          vim.api.nvim_feedkeys(t '<Up>', 'n', true)
        end
      end, -- }}}
      i = function(fallback) -- insert mode mappings {{{
        if cmp.visible() then
          cmp.select_prev_item { behavior = cmp.SelectBehavior.Select }
        else
          fallback()
        end
      end, -- }}}
    },
    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-e>'] = cmp.mapping { i = cmp.mapping.abort(), c = cmp.mapping.close() },
    ['<CR>'] = cmp.mapping.confirm { select = false },
  },
  sources = cmp.config.sources {
    { name = 'nvim_lsp', priority = 9, group_index = 1 },
    { name = 'nvim_lsp_signature_help', group_index = 1 },
    { name = 'luasnip', priority = 10, group_index = 1 },
    { name = 'git', group_index = 1 },
    { name = 'latex_symbols', group_index = 2 },
    {
      name = 'rg',
      option = {
        additional_arguments = { '--max-depth 4', '--hidden', '--glob !*/.git/*' },
      },
      group_index = 2,
    },
    { name = 'cmp_tabnine', group_index = 2 },
    { name = 'buffer', group_index = 2 },
    { name = 'spell', group_index = 2 },
    { name = 'neorg', group_index = 1 },
    { name = 'crates', group_index = 1 },
  },
  sorting = {
    comparators = {
      cmp.config.compare.kind,
      cmp.config.compare.recently_used,
      cmp.config.compare.score,
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },
  },
}

-- Use buffer source for `/`.
cmp.setup.cmdline('/', {
  sources = { { name = 'buffer' } },
  window = {
    completion = {
      border = { '', '', '', '', '', '', '', '' },
    },
    documentation = {
      border = { '', '', '', '', '', '', '', '' },
    },
  },
})

-- Use cmdline & path source for ':'.
cmp.setup.cmdline(':', {
  sources = cmp.config.sources({ { name = 'path' } }, { { name = 'cmdline' } }),
})

require('cmp_git').setup {
  filetypes = { 'gitcommit', 'NeogitCommitMessage', 'octo', 'gitrebase' },
  remotes = { 'upstream', 'origin', 'github' },
}

local source_icons = { -- source icons in the menu {{{
  buffer = '[ ]',
  nvim_lsp = '[ ]',
  luasnip = '[ ]',
  git = '[ ]',
  latex_symbols = '[ ]',
  rg = '[ ]',
  spell = '[ ]',
  cmp_tabnine = '[ ]',
} -- }}}

cmp.setup {
  window = {
    completion = {
      winhighlight = 'Normal:Pmenu,FloatBorder:Pmenu,Search:None',
      col_offset = -3,
      side_padding = 0,
    },
    documentation = {
      winhighlight = 'Normal:Pmenu,FloatBorder:Pmenu,Search:None',
      side_padding = 0,
    },
  },
  formatting = {
    fields = { 'kind', 'abbr', 'menu' },
    format = function(entry, vim_item)
      local kind = require('lspkind').cmp_format { mode = 'symbol_text', maxwidth = 50 }(entry, vim_item)
      local strings = vim.split(kind.kind, '%s', { trimempty = true })
      strings[2] = strings[2] or '' -- we need to make sure this is not nil
      kind.kind = ' ' .. strings[1] .. ' ' -- icon of the kind
      local flex = 9 - #strings[2]
      local source = source_icons[entry.source.name] and string.rep(' ', flex) .. source_icons[entry.source.name]
      source = source or ''
      kind.menu = '    (' .. strings[2] .. ')' .. source

      return kind
    end,
  },
}
