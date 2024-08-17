---@diagnostic disable: undefined-global
local get_cstring = utils.get_cstring

-- TODO: Check whether the cursor is already in comment using tree-sitter and add comment delims only when not in
-- comment <12-05-23>
--- Options for marks to be used in a TODO comment
local marks = {
  signature = function()
    return fmt('<{}>', i(1, _G.luasnip.vars.username))
  end,
  signature_with_email = function()
    return fmt('<{}>', i(1, _G.luasnip.vars.username .. ' ' .. _G.luasnip.vars.email))
  end,
  date_signature_with_email = function()
    return fmt(
      '<{}>',
      i(1, os.date(_G.luasnip.vars.date_format) .. ', ' .. _G.luasnip.vars.username .. ' ' .. _G.luasnip.vars.email)
    )
  end,
  date_signature = function()
    return fmt('<{}>', i(1, os.date(_G.luasnip.vars.date_format) .. ', ' .. _G.luasnip.vars.username))
  end,
  date = function()
    return fmt('<{}>', i(1, os.date(_G.luasnip.vars.date_format)))
  end,
  empty = function()
    return t ''
  end,
}

local todo_snippet_nodes = function(aliases, opts)
  local aliases_nodes = vim.tbl_map(function(alias)
    return i(nil, alias)
  end, aliases)
  -- TODO: logic for allowed signature-marks for a given comment... should be in the paramlist
  -- somewhere <15-03-22, kunzaatko> --
  local sigmark_nodes = {}
  for _, mark in pairs(marks) do
    table.insert(sigmark_nodes, mark())
  end
  local comment_node = fmta('<> <>: <> <> <><>', {
    f(function()
      return get_cstring(opts.ctype)[1]
    end),
    c(1, aliases_nodes),
    i(3),
    c(2, sigmark_nodes),
    f(function()
      return get_cstring(opts.ctype)[2]
    end),
    i(0),
  })
  return comment_node
end

-- TODO: Should instead return a DynamicNode since if this is not the case, then the comment sting
-- in the `docstring will not change` --
--- Generate a TODO comment snippet with an automatic description and docstring
---@param context table merged with the generated context table `trig` must be specified
---@param aliases string[]|string of aliases for the todo comment (ex.: {FIX, ISSUE, FIXIT, BUG})
---@param opts table merged with the snippet opts table
local todo_snippet = function(context, aliases, opts)
  opts = opts or {}
  aliases = type(aliases) == 'string' and { aliases } or aliases
  context = context or {}
  if not context.trig then
    return error("context doesn't include a `trig` key which is mandatory", 2)
  end
  opts.ctype = opts.ctype or 1
  local alias_string = table.concat(aliases, '|')
  context.name = context.name or (alias_string .. ' comment')
  context.dscr = context.dscr or (alias_string .. ' comment with a signature-mark')
  context.docstring = context.docstring or (' {1:' .. alias_string .. '}: {3} <{2:mark}>{0} ')
  local comment_node = todo_snippet_nodes(aliases, opts)
  return s(context, comment_node, opts)
end

-- TODO: make a universal function for the todo comments <15-03-22, kunzaatko> --
-- TODO: Enable *SELECT* mode for these snippets <13-03-22, kunzaatko> --

local todo_snippet_specs = {
  { { trig = 'todo' }, 'TODO' },
  { { trig = 'fix' }, { 'FIX', 'BUG', 'ISSUE', 'FIXIT' } },
  { { trig = 'hack' }, 'HACK' },
  { { trig = 'warn' }, { 'WARN', 'QUESTION', 'WARNING', 'XXX' } },
  { { trig = 'perf' }, { 'PERF', 'PERFORMANCE', 'OPTIM', 'OPTIMIZE' } },
  { { trig = 'note' }, { 'NOTE', 'INFO', 'IDEA', 'IDEA!', 'RESEARCH' } },
  -- NOTE: Block commented todo-comments <kunzaatko>
  { { trig = 'todob' }, 'TODO', { ctype = 2 } },
  { { trig = 'fixb' }, { 'FIX', 'BUG', 'ISSUE', 'FIXIT' }, { ctype = 2 } },
  { { trig = 'hackb' }, 'HACK', { ctype = 2 } },
  { { trig = 'warnb' }, { 'WARN', 'QUESTION', 'WARNING', 'XXX' }, { ctype = 2 } },
  { { trig = 'perfb' }, { 'PERF', 'PERFORMANCE', 'OPTIM', 'OPTIMIZE' }, { ctype = 2 } },
  { { trig = 'noteb' }, { 'NOTE', 'INFO' }, { ctype = 2 } },
}

for _, v in ipairs(todo_snippet_specs) do
  -- NOTE: 3rd argument accepts nil
  todo_snippet(v[1], v[2], v[3])
end

-- TODO: This does not work right now somehow. Should fix this. <17-03-22> --
--[[
local todo_comment_nodes = { i(1, '') }
for _, v in ipairs(todo_snippet_specs) do
  -- NOTE: 3rd argument accepts nil
  table.insert(todo_comment_nodes, todo_snippet_nodes(type(v[2]) == 'string' and { v[2] } or v[2], v[3] or {}))
end

local docstring = function()
  local docstring = {}
  for _, v in ipairs(todo_comment_snippets) do
    vim.list_extend(docstring, v.snippet.docstring)
  end
  return table.concat(docstring, '\n')
end

vim.list_extend(todo_comment_snippets, {
  s({
    trig = 'tcom',
    name = 'Annotated comment',
    dscr = 'Choose between anotated comments from TODO-comments',
    docstring = docstring(),
  }, c(1, todo_comment_nodes)),
})
-- ]]
