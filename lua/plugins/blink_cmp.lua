-- FIX: `Field` completion type should have a brighter colour and a different icon from the `Variable` and the variable
-- should also be a bit more contrasty <08-04-25>
return {
  'saghen/blink.cmp',
  dependencies = {
    { 'L3MON4D3/LuaSnip', version = 'v2.*' },
    'erooke/blink-cmp-latex',
    'mikavilpas/blink-ripgrep.nvim',
    'Kaiser-Yang/blink-cmp-git',
    'archie-judd/blink-cmp-words',
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
        markdown = { inherit_defaults = true, 'markdown', 'thesaurus', 'git' },
        tex = { inherit_defaults = true, 'dictionary', 'thesaurus' },
        text = { inherit_defaults = true, 'dictionary', 'thesaurus' },
        octo = { inherit_defautls = true, 'git' }, gitcommit = { inherit_defautls = true, 'git', 'conventional_commits', 'markdown' }, ['NeogitCommitMessage'] = { inherit_defautls = true, 'git', 'conventional_commits', 'markdown' }, gitrebase = { inherit_defautls = true, 'git' },
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
          opts = {
            -- Default pointers define the lexical relations listed under each definition,
            -- see Pointer Symbols below.
            -- Default is as below ("antonyms", "similar to" and "also see").
            pointer_symbols = { '!', '&', '^' },
          },
        },
        dictionary = {
          name = 'Words Dictionary',
          module = 'blink-cmp-words.dictionary',
          max_items = 4,
          opts = {
            dictionary_search_threshold = 3, -- Number of characters to trigger completion (if slow increase)
            pointer_symbols = { '!', '&', '^' }, -- See thesaurus
          },
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
