return {
  'nvim-neorg/neorg',
  dependencies = {
    {
      'vhyrro/luarocks.nvim',
      priority = 1000,
      config = true,
    },
  },
  lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
  version = '*', -- Pin Neorg to the latest stable release
  config = true,
  opts = {
    load = {
      ['core.defaults'] = {},
      ['core.concealer'] = {},
      ['core.integrations.treesitter'] = {},
      ['core.completion'] = {
        config = {
          engine = 'nvim-cmp',
        },
      },
      ['core.dirman'] = {
        config = {
          workspaces = {
            notes = '~/Notes',
          },
        },
      },
    },
  },
}
