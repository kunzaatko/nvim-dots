local M = {}
-- installing packer, if it is not already installed
local fn, cmd = vim.fn, vim.cmd

M.packer_install = function()
  local install_path = fn.stdpath 'data' .. '/site/pack/packer/opt/packer.nvim'

  if fn.empty(fn.glob(install_path)) > 0 then
    _G.packer_bootstrap = fn.system {
      'git',
      'clone',
      '--depth',
      '1',
      'https://github.com/wbthomason/packer.nvim',
      install_path,
    }
  end

  -- if packer was installed, sync the plugins
  if _G.packer_bootstrap then
    cmd 'packadd packer.nvim'
    require('pkg').sync()
  end
end

return M
