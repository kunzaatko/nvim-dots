-- installing packer, if it is not already installed
local cmd, fn = vim.fn, vim.cmd

local install_path = fn.stdpath('data') .. '/site/pack/packer/opt/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  cmd([[!git clone https://github.com/wbthomason/packer.nvim ]] .. install_path)

  cmd 'packadd packer.nvim'
end
