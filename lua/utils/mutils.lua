local cmd = vim.cmd

-- map utilities
_G.MUtils = {}

MUtils.append_blank_lines = function()
  vim.fn.append(vim.api.nvim_win_get_cursor(0)[1],
                vim.fn["repeat"]({""}, vim.api.nvim_get_vvar("count1")))
end

-- TODO: Does not work <09-05-21, kunzaatko> --
MUtils.save_root = function()
  vim.fn.execute("silent! write !sudo tee % >/dev/null | edit!<CR>")
end

MUtils.packer_install = function(f_args)
  require 'pkg.install_packer'
  cmd 'packadd packer.nvim'
  if f_args then
    require'packer'.install(f_args)
  else
    require'pkg'.install()
  end
end

MUtils.packer_update = function(f_args)
  require 'pkg.install_packer'
  cmd 'packadd packer.nvim'
  if f_args then
    require'packer'.update(f_args)
  else
    require'pkg'.update()
  end
end

MUtils.packer_sync = function(f_args)
  require 'pkg.install_packer'
  cmd 'packadd packer.nvim'
  if f_args then
    require'packer'.sync(f_args)
  else
    require'pkg'.sync()
  end
end
