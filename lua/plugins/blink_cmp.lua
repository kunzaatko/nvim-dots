-- FIX: `Field` completion type should have a brighter colour and a different icon from the `Variable` and the variable
-- should also be a bit more contrasty <08-04-25>
return {
  'saghen/blink.cmp',
  version = 'v1.*',
  dependencies = {
    { 'L3MON4D3/LuaSnip', version = 'v2.*' },
    'erooke/blink-cmp-latex',
    'mikavilpas/blink-ripgrep.nvim',
    'Kaiser-Yang/blink-cmp-git',
    'archie-judd/blink-cmp-words',
    'disrupted/blink-cmp-conventional-commits',
  },
  lazy = false,
  -- event = { 'InsertEnter', 'VeryLazy' },
  -- build = 'cargo build --release',

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

    -- FIX: When using enter, always accept only if there is a first letter in the completion present. This would avoid
    -- the enter at the end of the line expanding to a snippet or a completion <05-09-25>

    sources = {
      default = {
        'lsp',
        'path',
        'snippets',
        'ripgrep',
      },
      -- stylua: ignore start
      per_filetype = {
        'codecompanion',
        julia = { inherit_defaults = true, 'latex' },
        lua = { inherit_defaults = true, 'lazydev' },
        rust = { 'lsp', 'path', 'snippets', 'ripgrep' },
        markdown = { inherit_defaults = true, 'markdown', 'thesaurus', 'git', 'latex' },
        tex = { inherit_defaults = true, 'dictionary', 'thesaurus' },
        text = { inherit_defaults = true, 'dictionary', 'thesaurus' },
        octo = { inherit_defaults = true, 'git' }, gitcommit = { inherit_defaults = true, 'git', 'conventional_commits', 'markdown' }, ['NeogitCommitMessage'] = { inherit_defaults = true, 'git', 'conventional_commits', 'markdown' }, gitrebase = { inherit_defaults = true, 'git' },
      },
      -- stylua: ignore end

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
          max_items = 5,
          fallbacks = { 'buffer' },
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
        latex = {
          name = 'LaTeX',
          module = 'blink-cmp-latex',
          enabled = function()
            return vim.tbl_contains(
              { 'octo', 'gitcommit', 'markdown', 'NeogitCommitMessage', 'gitrebase', 'julia' },
              vim.bo.filetype
            )
          end,
          opts = {
            insert_command = false,
          },
        },
        thesaurus = {
          name = 'Words Thesaurus',
          module = 'blink-cmp-words.thesaurus',
          max_items = 4,
        },
        dictionary = {
          name = 'Words Dictionary',
          module = 'blink-cmp-words.dictionary',
          max_items = 4,
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
        -- FIX: Currently the completion sorter does not compile, so I use the pre-compiled binary. When it compiles
        -- again, I should toggle this to build with optimizations. Also the `build` should be re-enabled <19-02-2026>
        download = true,
      },
      sorts = {
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
