---@diagnostic disable: undefined-global
local get_cstring = utils.get_cstring

-- NOTE: They are functions that generate the nodes instead of the nodes themselves because of a reference issue in
-- LuaSnip that causes a stackoverflow if multiple snippets use the same nodes as options for a choice node <09-09-24>
-- TODO: Check whether the cursor is already in comment using tree-sitter and add comment delims only when not in
-- comment <12-05-23>
-- TODO: These should be be made more modular. I can create the nodes of the snippets like "date_nodes",
-- "username_nodes" etc. beforehand and they can be combined into the final snippet <07-09-24>
--- Options for marks to be used in a TODO comment
local sigmarks = {
  signature = function()
    return extras.partial(function()
      return '<' .. _G.luasnip.vars.username .. '>'
    end)
  end,
  signature_with_email = function()
    return extras.partial(function()
      return '<' .. _G.luasnip.vars.username .. ' ' .. _G.luasnip.vars.email .. '>'
    end)
  end,
  date_signature_with_email = function()
    return extras.partial(function()
      return '<'
        .. os.date(_G.luasnip.vars.date_format)
        .. ', '
        .. _G.luasnip.vars.username
        .. ' '
        .. _G.luasnip.vars.email
        .. '>'
    end)
  end,
  date_signature = function()
    return extras.partial(function()
      return '<' .. os.date(_G.luasnip.vars.date_format) .. ', ' .. _G.luasnip.vars.username .. '>'
    end)
  end,
  date = function()
    return extras.partial(function()
      return '<' .. os.date(_G.luasnip.vars.date_format) .. '>'
    end)
  end,
  empty = function()
    return t ''
  end,
}

-- TODO: make a universal function for the todo comments <15-03-22, kunzaatko> --
-- TODO: Enable *SELECT* mode for these snippets <13-03-22, kunzaatko> --
-- TODO: Should instead return a DynamicNode since if this is not the case, then the comment sting
-- in the `docstring will not change` --
--- Generate a TODO comment snippet with an automatic description and docstring
---@param context table merged with the generated context table `trig` must be specified
---@param aliases string[] of aliases for the todo comment (ex.: {FIX, ISSUE, FIXIT, BUG})
---@param opts table merged with the snippet opts table
---@param marks table signatures that are available in the final choice node
local todo_snippet = function(context, aliases, opts, marks)
  marks = marks or {}
  opts = opts or {}

  context = context or {}
  if not context.trig then
    return error("context doesn't include a `trig` key which is mandatory", 2)
  end
  opts.ctype = opts.ctype or 1
  local alias_string = table.concat(aliases, '|')
  context.name = context.name or (alias_string .. ' comment')
  context.dscr = context.dscr or (alias_string .. ' comment with a signature-mark')
  context.docstring = context.docstring or (' {1:' .. alias_string .. '}: {3} <{2:mark}>{0} ')

  local aliases_nodes = vim.tbl_map(function(alias)
    return i(nil, alias)
  end, aliases)
  local comment_node = fmta('<> <>: <> <> <><>', {
    f(function()
      return get_cstring(opts.ctype)[1]
    end),
    c(1, aliases_nodes),
    i(3),
    c(2, marks),
    f(function()
      return get_cstring(opts.ctype)[2]
    end),
    i(0),
  })
  return s(context, comment_node, opts)
end

local todo_snippet_specs = {
  {
    { trig = 'todo' },
    { 'TODO' },
    {},
    { 'date', 'empty', 'date_signature', 'signature_with_email', 'date_signature_with_email', 'signature' },
  },
  {
    { trig = 'fix' },
    { 'FIX', 'BUG', 'ISSUE', 'FIXIT' },
    {},
    { 'date', 'empty', 'date_signature', 'signature_with_email', 'date_signature_with_email', 'signature' },
  },
  {
    { trig = 'hack' },
    { 'HACK' },
    {},
    { 'date', 'empty', 'date_signature', 'signature_with_email', 'date_signature_with_email', 'signature' },
  },
  {
    { trig = 'warn' },
    { 'WARN', 'QUESTION', 'WARNING', 'XXX' },
    {},
    { 'date', 'empty', 'date_signature', 'signature_with_email', 'date_signature_with_email', 'signature' },
  },
  {
    { trig = 'perf' },
    { 'PERF', 'PERFORMANCE', 'OPTIM', 'OPTIMIZE' },
    {},
    { 'date', 'empty', 'date_signature', 'signature_with_email', 'date_signature_with_email', 'signature' },
  },
  {
    { trig = 'note' },
    { 'NOTE', 'INFO', 'IDEA', 'IDEA!', 'RESEARCH' },
    {},
    { 'date', 'empty', 'date_signature', 'signature_with_email', 'date_signature_with_email', 'signature' },
  },
  -- NOTE: Block commented todo-comments <kunzaatko>
  {
    { trig = 'todob' },
    { 'TODO' },
    { ctype = 2 },
    { 'date', 'empty', 'date_signature', 'signature_with_email', 'date_signature_with_email', 'signature' },
  },
  {
    { trig = 'fixb' },
    { 'FIX', 'BUG', 'ISSUE', 'FIXIT' },
    { ctype = 2 },
    { 'date', 'empty', 'date_signature', 'signature_with_email', 'date_signature_with_email', 'signature' },
  },
  {
    { trig = 'hackb' },
    { 'HACK' },
    { ctype = 2 },
    { 'date', 'empty', 'date_signature', 'signature_with_email', 'date_signature_with_email', 'signature' },
  },
  {
    { trig = 'warnb' },
    { 'WARN', 'QUESTION', 'WARNING', 'XXX' },
    { ctype = 2 },
    { 'date', 'empty', 'date_signature', 'signature_with_email', 'date_signature_with_email', 'signature' },
  },
  {
    { trig = 'perfb' },
    { 'PERF', 'PERFORMANCE', 'OPTIM', 'OPTIMIZE' },
    { ctype = 2 },
    { 'date', 'empty', 'date_signature', 'signature_with_email', 'date_signature_with_email', 'signature' },
  },
  {
    { trig = 'noteb' },
    { 'NOTE', 'INFO' },
    { ctype = 2 },
    { 'date', 'empty', 'date_signature', 'signature_with_email', 'date_signature_with_email', 'signature' },
  },
}

for _, v in pairs(todo_snippet_specs) do
  local marks = {}
  for _, m in pairs(v[4]) do
    table.insert(marks, sigmarks[m]())
  end
  todo_snippet(v[1], v[2], v[3], marks)
end
