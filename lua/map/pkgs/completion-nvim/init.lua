require'map.pkgs.completion-nvim.utils'
local map = require'utils'.map

map('i', '<tab>', '<Plug>(completion_smart_tab)')
map('i', '<s-tab>', '<Plug>(completion_smart_s_tab)')

vim.g.completion_confirm_key = ""
map('i' , '<CR>','v:lua.MUtils.completion_confirm()', {expr = true , noremap = true})

-- TODO: Why dont these work? <07-03-21, kunzaatko> --
--[[ map('i' , '<c-j>','v:lua.MUtils.smart_pum_snip_fwd()', {expr = true , noremap = true})
map('i' , '<c-k>','v:lua.MUtils.smart_pum_snip_bwd()', {expr = true , noremap = true}) ]]

-- these mappings XXX work like this:
--                  if pum is visible:
--                     if something is selected:
--                          <Plug>...
--                     else:
--                          hide pum
--                          XXX

map('i', '<c-j>',
    [[pumvisible() ? complete_info()["selected"] != "-1" ? "\<Plug>(completion_smart_tab)" : "\<c-e>\<c-j>" : "\<c-j>"]],
    {expr = true})
map('i', '<c-k>',
    [[pumvisible() ? complete_info()["selected"] != "-1" ? "\<Plug>(completion_smart_s_tab)" : "\<c-e>\<c-k>" : "\<c-k>"]],
    {expr = true})

