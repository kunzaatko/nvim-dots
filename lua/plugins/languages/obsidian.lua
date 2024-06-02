-- TODO: Configure <13-09-23>
return {
  'epwalsh/obsidian.nvim',
  lazy = true,
  event = {
    'BufReadPre ' .. vim.fn.expand '~' .. '/Obsidian/**.md',
    'BufNewFile ' .. vim.fn.expand '~' .. '/Obsidian/**.md',
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  opts = {
    dir = '~/Obsidian',
    disable_frontmatter = true,
    daily_notes = {
      folder = 'Org Notes/Daily Notes',
    },
  },
}
