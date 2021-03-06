local cmd = vim.cmd

local function opt(key, value, scopes)
  scopes = scopes or {vim.o} -- if the scopes are not specified, then global scoped option
  for _, s in pairs(scopes) do
    s[key] = value
  end -- define option for every scope
end

local function autocmd(group, cmds)
  if type(cmds) == 'string' then
    cmds = {cmds}
  end -- if there is only one command
  cmd('augroup ' .. group)
  cmd 'autocmd!'
  for _, c in pairs(cmds) do
    cmd('autocmd ' .. c)
  end
  cmd 'augroup END'
end

local function map(modes, lhs, rhs, opts)
  opts = opts or {}
  if type(modes) == 'string' then
    modes = {modes}
  end
  for _, mode in pairs(modes) do
    vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
  end
end

local function map_local(buf, modes, lhs, rhs, opts)
  opts = opts or {}
  if type(modes) == 'string' then
    modes = {modes}
  end
  for _, mode in pairs(modes) do
    vim.api.nvim_buf_set_keymap(buf, mode, lhs, rhs, opts)
  end
end

return {opt = opt, autocmd = autocmd, map = map, map_local = map_local}
