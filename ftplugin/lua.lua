local opt = vim.opt

--[[ expandtab = expand a tab into spaces,
     tabstop,shiftwidth - # of spaces for <tab> (tabstop) in insert and for
                          <<,>> in normal (shiftwidth)
     shiftround = round to nearest multiple of shiftwidth ]]
local indent = 2
opt.expandtab, opt.shiftround = true, true
opt.tabstop, opt.shiftwidth = indent, indent
