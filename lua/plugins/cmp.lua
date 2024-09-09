-- NOTE: https://www.reddit.com/r/neovim/comments/1f1rxtx/share_a_tip_to_improve_your_experience_in_nvimcmp/ <27-08-24>
local M = {
  -- 'hrsh7th/nvim-cmp',
  'yioneko/nvim-cmp',
  branch = 'perf',
  name = 'cmp',
  event = { 'InsertEnter', 'VeryLazy' },
  dependencies = {
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'onsails/lspkind.nvim',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/cmp-nvim-lsp-signature-help',
    'saadparwaiz1/cmp_luasnip',
    { 'petertriho/cmp-git', dependencies = { 'nvim-lua/plenary.nvim', name = 'plenary' } },
    'kdheepak/cmp-latex-symbols',
    'lukas-reineke/cmp-rg',
    'f3fora/cmp-spell',
    'hrsh7th/cmp-nvim-lsp',
  },
}

function M.config()
  local cmp = require 'cmp'
  local luasnip = require 'luasnip'

  local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match '%s' == nil
  end

  local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
  end

  -- NOTE: https://www.reddit.com/r/neovim/comments/1f1rxtx/share_a_tip_to_improve_your_experience_in_nvimcmp/ <27-08-24>
  cmp.setup {
    preformance = {
      debounce = 0, -- default is 60ms
      throttle = 0, -- default is 30ms
    },
    preselect = cmp.PreselectMode.None,
    experimental = {
      ghost_text = true,
    },
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body) -- generate of LSP snippets
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
          elseif require('neogen').jumpable() then -- docs jump next
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
        debounce = 500,
        option = {
          additional_arguments = '--max-depth 4 --smart-case --glob "!***/.git/*" --hidden',
        },
        group_index = 2,
        keyword_length = 5,
      },
      -- { name = 'cmp_tabnine', group_index = 2 },
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

  -- TODO: Change the colour for enum and keyword <kunzaatko>
  local source_icons = { -- source icons in the menu {{{
    buffer = string.format('[%s]', static.icons.cmp.buffer),
    nvim_lsp = string.format('[%s]', static.icons.cmp.lsp),
    luasnip = string.format('[%s]', static.icons.cmp.luasnip),
    git = string.format('[%s]', static.icons.cmp.git),
    latex_symbols = string.format('[%s]', static.icons.cmp.latex),
    rg = string.format('[%s]', static.icons.cmp.ripgrep),
    spell = string.format('[%s]', static.icons.cmp.spell),
    -- cmp_tabnine = '[ ]',
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
        local kind_name = strings[2] or '' -- we need to make sure this is not nil
        kind_name = kind_name == 'Text' and '' or kind_name -- do not show the kind name when it is 'String'
        kind.kind = ' ' .. strings[1] .. ' ' -- icon of the kind
        local flex = 9 - #kind_name
        local source = source_icons[entry.source.name] and string.rep(' ', flex) .. source_icons[entry.source.name]
        source = source or ''
        kind.menu = (kind_name ~= '' and '(' or ' ') .. kind_name .. (kind_name ~= '' and ')' or ' ') .. source

        return kind
      end,
    },
  }
end

return M
