local ls = require 'luasnip'

local s = ls.snippet
local r = ls.restore_node
local f = ls.function_node
local i = ls.insert_node
local t = ls.text_node
local c = ls.choice_node
local fmta = require('luasnip.extras.fmt').fmta

local M = {}

--luacheck: no max line length
--- Generate nodes for a simple environment
---@param envname string name of the environment to put as the \begin \end arguments
---@param restore string key for restore key if should be restore snippet (it assures that we define the restore node only once using a `_cache` variable)
---@return table environment_snippet_nodes
M.simple_env_nodes = function(envname, restore) --{{{
  --luacheck: max line length 120
  --[[ NOTE:1) we already have the same key ]]
  --[[ NOTE:2) We do not have this key yet ]]
  --[[ NOTE:3) We do not want to restore ]]
  local middle_node = restore and restore == _G.luasnip._cache.simple_env_nodes_restore_key and r(1, restore)
    or restore and r(1, restore, i(1))
    or i(1)
  if restore then
    _G.luasnip._cache.simple_env_nodes_restore_key = restore
  end
  return fmta(
    [[
  \begin{<>}
     <>
  \end{<>}
  ]],
    { t(envname), middle_node, t(envname) }
  )
end --}}}

-- TODO: Automatic VISUAL mode snippets <19-03-22> --
--- Generate a snippet that wraps a capture by a command
---@param context table merged with the generated context table `trig` must be specified
---@param command string LaTeX symbol command
---@param opts table merged with the snippet opts table
---@return function capture wrap snippet
M.capture_wrap_snippet = function(context, command, opts) --{{{
  opts = opts or {}
  if not context.trig then
    error("context doesn't include a `trig` key which is mandatory", 2)
  end
  context.regTrig = context.regTrig or true
  context.dscr = context.dscr or command
  context.name = context.name or context.dscr
  context.docstring = context.docstring or (command .. [[{]] .. [[{capture}]] .. [[}]] .. [[{0}]])
  return s(
    context,
    f(function(_, snip)
      return command .. [[{]] .. snip.captures[1] .. [[}]]
    end),
    opts
  )
end --}}}

-- TODO: Automatic VISUAL mode snippets <19-03-22> --
-- TODO: Automatically add space after if no space inserted <19-03-22> --
--- Generate a snippet with simple LaTeX command with one parameter
---@param context table merged with the generated context table `trig` must be specified
---@param command string LaTeX symbol command
---@param opts table merged with the snippet opts table
---@return function simple function snippet
M.simple_command_snippet = function(context, command, opts) --{{{
  opts = opts or {}
  if not context.trig then
    error("context doesn't include a `trig` key which is mandatory", 2)
  end
  context.dscr = context.dscr or command
  context.name = context.name or context.dscr
  context.docstring = context.docstring or (command .. [[{]] .. [[{1}]] .. [[}]] .. [[{0}]])
  return s(context, fmta(command .. [[{<>}]], i(1)), opts)
end --}}}

--- Generate a snippet with for LaTeX command that is indexed
---@param context table merged with the generated context table `trig` must be specified
---@param command string LaTeX command
---@param indexes table list-like table of indexers
---@param opts table merged with the snippet opts table
---@return function indexing_command_snippet
M.indexing_command_snippet = function(context, command, indexes, opts) --{{{
  opts = opts or {}
  if not context.trig then
    error("context doesn't include a `trig` key which is mandatory", 2)
  end
  -- NOTE: This regular expresion trigger is here to disable expanding after first expansion at the i(1) of indexers
  context.trig = '[^\\]' .. context.trig
  indexes = indexes or require('snippets.latex.utils').snippet_parts.indexers
  local indexing_snippets = {}
  for _, v in pairs(indexes) do
    table.insert(indexing_snippets, v())
  end
  context.dscr = context.dscr or (command .. 'with choice for index')
  context.name = context.name or command
  context.regTrig = true
  context.docstring = context.docstring or (command .. '{index}' .. '{1}{0}')
  return s(context, fmta([[<><> <>]], { t(command), c(1, indexing_snippets), i(2) }), opts)
end --}}}

--- Generate a snippet with for LaTeX command that is indexed
---@param context table merged with the generated context table `trig` must be specified
---@param opts table merged with the snippet opts table
---@return function auto_backslash_snippet
M.auto_backslash_snippet = function(context, opts) --{{{
  opts = opts or {}
  if not context.trig then
    error("context doesn't include a `trig` key which is mandatory", 2)
  end
  context.dscr = context.dscr or (context.trig .. 'with automatic backslash')
  context.name = context.name or context.trig
  context.docstring = context.docstring or ([[\]] .. context.trig)
  return s(context, t([[\]] .. context.trig), opts)
end --}}}

--- Generate a delimiter snippet
---@param context table merged with the generated context table `trig` must be specified
---@param delimiters table {left_delim, right_delim} where the contents are strings
---@param opts table mreged with the snippet opts table
---@return function delimiter snippet
M.delimiter_snippet = function(context, delimiters, opts) -- {{{
  opts = opts or {}
  if not context.trig then
    error("context doesn't include a `trig` key which is mandatory", 2)
  end
  context.dscr = context.dscr or context.name and (context.name .. ' delimiters')
  context.docstring = context.docstring or (delimiters[1] .. [[{1}]] .. delimiters[2])
  context.wordTrig = context.wordTrig or true
  return s(context, fmta([[<> <> <>]], { t(delimiters[1]), i(1), t(delimiters[2]) }), opts)
end -- }}}

--- Generate a symbol snippet
---@param context table merged with the generated context table `trig` must be specified
---@param command string LaTeX symbol command
---@param opts table merged with the snippet opts table
---@return function symbol snippet
M.symbol_snippet = function(context, command, opts) --{{{
  opts = opts or {}
  if not context.trig then
    error("context doesn't include a `trig` key which is mandatory", 2)
  end
  context.dscr = context.dscr or command
  context.name = context.name or command:gsub([[\]], '')
  context.docstring = context.docstring or (command .. [[{0}]])
  context.wordTrig = context.wordTrig or false
  return s(context, t(command), opts)
end --}}}

--- Generate a snippet with for LaTeX command that is indexed
---@param context table merged with the generated context table `trig` must be specified
---@param opts table merged with the snippet opts table
---@return function auto_backslash_snippet
M.auto_backslash_argument_command_snippet = function(context, opts) --{{{
  opts = opts or {}
  if not context.trig then
    error("context doesn't include a `trig` key which is mandatory", 2)
  end
  context.dscr = context.dscr or (context.trig .. 'with automatic backslash')
  context.name = context.name or context.trig
  context.docstring = context.docstring or ([[\]] .. context.trig .. [[{{1}}{0}]])
  return s(context, fmta([[\]] .. context.trig .. [[{<>}]], i(1)), opts)
end --}}}

return M
