local npairs = require('nvim-autopairs')

_G.MUtils.completion_confirm = function()--{{{
  if vim.fn.pumvisible() ~= 0 then
    if vim.fn.complete_info()["selected"] ~= -1 then
      require'completion'.confirmCompletion()
      return npairs.esc("<c-y>")
    else
      vim.fn.nvim_select_popupmenu_item(0, false, false, {})
      require'completion'.confirmCompletion()
      return npairs.esc("<c-n><c-y>")
    end
  else
    return npairs.check_break_line_char()
  end
end--}}}

_G.MUtils.smart_pum_snip_fwd = function ()--{{{
    if vim.fn.pumvisible() ~= 0 then
        if vim.fn.complete_info()["selected"] ~= -1 then
            require'completion'.smart_tab()
        else
            vim.call"UltiSnips#JumpForwards()"
        end
    else
        vim.call"UltiSnips#JumpForwards()"
    end
end--}}}

_G.MUtils.smart_pum_snip_bwd = function ()--{{{
    if vim.fn.pumvisible() ~= 0 then
        if vim.fn.complete_info()["selected"] ~= -1 then
            require'completion'.smart_tab()
        else
            vim.call"UltiSnips#JumpBackwards()"
        end
    else
        vim.call"UltiSnips#JumpForwards()"
    end
end--}}}
