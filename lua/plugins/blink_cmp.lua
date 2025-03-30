return {
  'saghen/blink.cmp',
  dependencies = {
    { 'L3MON4D3/LuaSnip', version = 'v2.*' },
    { 'saghen/blink.compat', lazy = true, config = true },
    'mikavilpas/blink-ripgrep.nvim',
    'moyiz/blink-emoji.nvim',
    'bydlw98/blink-cmp-env',
    'ribru17/blink-cmp-spell',
    'dmitmel/cmp-digraphs',
    {
      'Kaiser-Yang/blink-cmp-git',
      dependencies = { 'nvim-lua/plenary.nvim' },
    },
    'kdheepak/cmp-latex-symbols',
    'disrupted/blink-cmp-conventional-commits',
  },
  lazy = false,
  build = 'cargo build --release',

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = {
      preset = 'enter',
      ['<A-i>'] = { 'show', 'hide', 'fallback' }, -- NOTE: Toggle
      ['<Tab>'] = { 'select_next', 'fallback' },
      ['<S-Tab>'] = { 'select_prev', 'fallback' },
      -- NOTE: Removes the default keymap (show signature_help). Mapped to move up or jump in snippet in LuaSnips.
      ['<C-K>'] = { 'fallback' },
    },

    snippets = {
      preset = 'luasnip',
      expand = function(snippet)
        require('luasnip').lsp_expand(snippet)
      end,
      active = function(filter)
        if filter and filter.direction then
          return require('luasnip').jumpable(filter.direction)
        end
        return require('luasnip').in_snippet()
      end,
      jump = function(direction)
        require('luasnip').jump(direction)
      end,
    },
    sources = {
      default = {
        'lazydev',
        'lsp',
        'path',
        'snippets',
        'emoji',
        'git',
        'buffer',
        'ripgrep',
        'spell',
        'markdown',
        'env',
        'latex_symbols',
        'conventional_commits',
      },
      per_filetype = {
        'codecompanion',
        rust = { 'lsp', 'path', 'snippets', 'ripgrep' },
      },
      -- min_keyword_length = function()
      --   return vim.tbl_contains({ 'codecompanion', 'rust' }, vim.bo.filetype) and 0 or 1
      -- end,
      providers = {
        lsp = {
          async = true,
          score_offset = 5,
        },
        snippets = {
          score_offset = 3,
        },
        path = {
          score_offset = 4,
        },
        digraphs = {
          name = 'digraphs',
          score_offset = 1,
          module = 'blink.compat.source',
          opts = {
            cache_digraphs_on_start = true,
          },
        },
        buffer = {
          score_offset = -2,
          min_keyword_length = 3,
        },
        git = {
          name = 'git',
          module = 'blink-cmp-git',
          enabled = function()
            return vim.tbl_contains(
              { 'octo', 'gitcommit', 'markdown', 'NeogitCommitMessage', 'gitrebase' },
              vim.bo.filetype
            )
          end,
        },
        latex_symbols = {
          name = 'latex_symbols',
          module = 'blink.compat.source',
        },
        spell = {
          name = 'spell',
          score_offset = -2,
          module = 'blink-cmp-spell',
          opts = {
            enable_in_context = function()
              local curpos = vim.api.nvim_win_get_cursor(0)
              local captures = vim.treesitter.get_captures_at_pos(0, curpos[1] - 1, curpos[2] - 1)
              local in_spell_capture = false
              for _, cap in ipairs(captures) do
                if cap.capture == 'spell' then
                  in_spell_capture = true
                elseif cap.capture == 'nospell' then
                  return false
                end
              end
              return in_spell_capture
            end,
          },
        },

        markdown = { name = 'RenderMarkdown', module = 'render-markdown.integ.blink' },
        env = { name = 'Env', module = 'blink-cmp-env' },
        lazydev = {
          name = 'LazyDev',
          module = 'lazydev.integrations.blink',
          score_offset = 100,
        },
        ripgrep = {
          name = 'Ripgrep',
          module = 'blink-ripgrep',
        },
        emoji = {
          name = 'Emoji',
          module = 'blink-emoji',
          score_offset = 15,
          should_show_items = function()
            return vim.tbl_contains({ 'gitcommit', 'markdown' }, vim.o.filetype)
          end,
        },
        conventional_commits = {
          name = 'Conventional Commits',
          module = 'blink-cmp-conventional-commits',
          score_offset = 15,
          enabled = function()
            return vim.bo.filetype == 'gitcommit'
          end,
        },
      },
    },

    signature = { enabled = true }, -- NOTE: experimental <13-12-24>

    completion = {
      documentation = {
        auto_show = true,
      },
      trigger = {
        prefetch_on_insert = true,
      },
      menu = {
        --- @module 'blink.cmp'
        --- @type blink.cmp.Draw
        draw = {
          -- treesitter = true,
          padding = { 0, 1 },
          columns = { { 'kind_icon', 'label', 'label_description', gap = 1 }, { 'kind', 'source_name', gap = 1 } },
        },
      },
      accept = {
        auto_brackets = {
          override_brackets_for_filetypes = {
            tex = { '{', '}' },
          },
        },
      },
    },

    fuzzy = {
      prebuilt_binaries = {
        download = false, -- NOTE: We are compiling them ourselves
      },
      sorts = {
        function(a, b) -- NOTE: Sort by label if we have two spell entries
          local sort = require 'blink.cmp.fuzzy.sort'
          if a.source_id == 'spell' and b.source_id == 'spell' then
            return sort.label(a, b)
          end
        end,
        'score',
        'kind',
        'label',
      },
    },

    -- opts_extend = { 'sources.default' },
  },
  config = function(_, opts)
    opts.completion.menu.draw.components = {
      kind_icon = {
        text = function(ctx)
          return ' ' .. ctx.kind_icon .. ctx.icon_gap .. ' '
        end,
      },
      kind = {
        text = function(ctx)
          return '(' .. ctx.kind .. ')'
        end,
      },
      source_name = {
        text = function(ctx)
          return '[' .. (static.icons.cmp[ctx.source_name] or ctx.source_name) .. ']'
        end,
      },
    }
    require('util.lsp').add_capabilities(require('blink.cmp').get_lsp_capabilities())
    require('blink.cmp').setup(opts)
  end,
}
