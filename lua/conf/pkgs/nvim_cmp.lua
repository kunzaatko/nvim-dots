local lspconfig = require 'lspconfig'

require 'utils.lsputils'

local capabilities = require'cmp_nvim_lsp'.update_capabilities(vim.lsp.protocol
                                                                 .make_client_capabilities())
local servers = {'bashls', 'texlab', 'ccls', 'rust_analyzer', 'vimls'}
for _, server in pairs(servers) do
  lspconfig[server].setup {
    on_attach = LSPUtils.on_attach,
    flags = {debounce_text_changes = 150},
    capabilities = capabilities,
  }
end

lspconfig.julials.setup {
  settings = {julia = {format = {indent = 2}}},
  on_attach = LSPUtils.on_attach,
  capabilities = capabilities,
}

lspconfig.pyright.setup {
  settings = {python = {formatting = {provider = 'yapf'}}},
  on_attach = LSPUtils.on_attach,
  capabilities = capabilities,
}

if packer_plugins['lua-dev'].loaded == true then
  local luadev = require'lua-dev'.setup({
    lspconfig = {
      on_attach = LSPUtils.on_attach,
      cmd = {'lua-language-server'},
      settings = {Lua = {diagnostics = {globals = {'packer_plugins'}}}},
    },
  })

  lspconfig.sumneko_lua.setup(luadev)
end

local cmp = require 'cmp'

-- ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

cmp.setup {
  snippet = {
    expand = function(args)
      vim.fn["UltiSnips#Anon"](args.body)
    end,
  },
  mapping = { -- {{{
    ["<Tab>"] = cmp.mapping({
      c = function()
        if cmp.visible() then
          cmp.select_next_item({behavior = cmp.SelectBehavior.Insert})
        else
          cmp.complete()
        end
      end,
      i = function(fallback)
        if cmp.visible() then
          cmp.select_next_item({behavior = cmp.SelectBehavior.Insert})
        elseif vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
          vim.api.nvim_feedkeys(t("<Plug>(ultisnips_jump_forward)"), 'm', true)
        else
          fallback()
        end
      end,
      s = function(fallback)
        if vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
          vim.api.nvim_feedkeys(t("<Plug>(ultisnips_jump_forward)"), 'm', true)
        else
          fallback()
        end
      end,
    }),
    ["<S-Tab>"] = cmp.mapping({
      c = function()
        if cmp.visible() then
          cmp.select_prev_item({behavior = cmp.SelectBehavior.Insert})
        else
          cmp.complete()
        end
      end,
      i = function(fallback)
        if cmp.visible() then
          cmp.select_prev_item({behavior = cmp.SelectBehavior.Insert})
        elseif vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
          return vim.api.nvim_feedkeys(t("<Plug>(ultisnips_jump_backward)"), 'm', true)
        else
          fallback()
        end
      end,
      s = function(fallback)
        if vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
          return vim.api.nvim_feedkeys(t("<Plug>(ultisnips_jump_backward)"), 'm', true)
        else
          fallback()
        end
      end,
    }),
    ['<Down>'] = cmp.mapping(cmp.mapping.select_next_item({
      behavior = cmp.SelectBehavior.Select,
    }), {'i'}),
    ['<Up>'] = cmp.mapping(cmp.mapping.select_prev_item({
      behavior = cmp.SelectBehavior.Select,
    }), {'i'}),
    ['<C-n>'] = cmp.mapping({
      c = function()
        if cmp.visible() then
          cmp.select_next_item({behavior = cmp.SelectBehavior.Select})
        else
          vim.api.nvim_feedkeys(t('<Down>'), 'n', true)
        end
      end,
      i = function(fallback)
        if cmp.visible() then
          cmp.select_next_item({behavior = cmp.SelectBehavior.Select})
        else
          fallback()
        end
      end,
    }),
    ['<C-p>'] = cmp.mapping({
      c = function()
        if cmp.visible() then
          cmp.select_prev_item({behavior = cmp.SelectBehavior.Select})
        else
          vim.api.nvim_feedkeys(t('<Up>'), 'n', true)
        end
      end,
      i = function(fallback)
        if cmp.visible() then
          cmp.select_prev_item({behavior = cmp.SelectBehavior.Select})
        else
          fallback()
        end
      end,
    }),
    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), {'i', 'c'}),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), {'i', 'c'}),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), {'i', 'c'}),
    ['<C-e>'] = cmp.mapping({i = cmp.mapping.abort(), c = cmp.mapping.close()}),
    ['<CR>'] = cmp.mapping({
      i = cmp.mapping.confirm({behavior = cmp.ConfirmBehavior.Replace, select = false}),
      c = function(fallback)
        if cmp.visible() then
          cmp.confirm({behavior = cmp.ConfirmBehavior.Replace, select = false})
        else
          fallback()
        end
      end,
    }),
  }, -- }}}
  sources = cmp.config.sources({
    {name = 'nvim_lsp'},
    {name = 'ultisnips'},
    {name = 'cmp_git'},
    {name = 'latex_symbols'},
    {
      name = 'rg',
      option = {
        additional_arguments = {'--max-depth 4', '--hidden', '--glob !*/.git/*'},
      },
    },
  }, {{name = 'buffer'}}),
  sorting = {
    comparators = {
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.sort_text,
      cmp.config.compare.score,
      cmp.config.compare.recently_used,
      cmp.config.compare.kind,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },
  },
}

-- Use buffer source for `/`.
cmp.setup.cmdline('/', {
  completion = {autocomplete = false},
  sources = {
    -- { name = 'buffer' }
    {name = 'buffer'},
  },
})

-- Use cmdline & path source for ':'.
cmp.setup.cmdline(':', {
  completion = {autocomplete = false},
  sources = cmp.config.sources({{name = 'path'}}, {{name = 'cmdline'}}),
})

require'cmp_git'.setup()

local lspkind = require('lspkind')
cmp.setup {
  formatting = {
    format = lspkind.cmp_format({
      with_text = true,
      menu = ({
        buffer = "[Buffer]",
        nvim_lsp = "[LSP]",
        ultisnips = "[UltiSnips]",
        latex_symbols = "[LaTeX]",
        cmp_git = "[Git]",
        rg = "[RG]",
      }),
      maxwidth = 50,
    }),
  },
}
