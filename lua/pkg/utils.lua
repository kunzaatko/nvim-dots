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

--- Create a table of strings as a product of the strings in the table
---@param keys table[string]
---@return table[string]
local function string_product(keys)
  if #keys == 1 then
    return keys[1]
  end
  local keys_copy = {}
  for _, key in ipairs(keys) do
    table.insert(keys_copy, key)
  end
  local product = {}
  local first = table.remove(keys_copy, 1)
  for _, a in ipairs(first) do
    if type(a) ~= 'string' then
      vim.cmd 'echoerr "Not a valid keys table"'
    end
    for _, b in ipairs(string_product(keys_copy)) do
      table.insert(product, a .. b)
    end
  end
  return product
end

local function expand_keys(keys)
  if type(keys) == 'string' then
    return { keys }
  elseif type(keys[1]) == 'string' then
    return keys
  else
    return string_product(keys)
  end
end

--- Create the mappings table for packer from the modes and as a product of strings in keys
---@param modes table[string]|string modes to to create the mappings in
---@param keys table[string]|string keys to make the mappings from
---@return table[table[string]] spec of mappings for packer
M.get_keys = function(modes, keys)
  if type(modes) == 'string' then
    modes = { modes }
  end
  local combinations = {}
  for _, mode in ipairs(modes) do
    for _, v in ipairs(expand_keys(keys)) do
      table.insert(combinations, { mode, v })
    end
  end
  return combinations
end

--- Gets the concatenation of the keys defined through get keys
---@param specs table[table] to be used for into the getkeys
M.get_multi_keys = function(specs)
  local combinations = {}
  for _, a in ipairs(specs) do
    for _, i in ipairs(M.get_keys(a[1], a[2])) do
      table.insert(combinations, i)
    end
  end
  return combinations
end

return M
