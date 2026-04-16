-- NOTE: Does not work with `hardtime.nvim` - https://github.com/chrisgrieser/nvim-origami/issues/6 <16-04-2026>
return {
  'chrisgrieser/nvim-origami',
  event = 'VeryLazy',
  opts = {},
  init = function()
    vim.opt.foldlevel = 99
    vim.opt.foldlevelstart = 99
  end,
}
