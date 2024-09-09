local M = {}

local ls = require 'luasnip'
local m = require('luasnip.extras').match
local sn = ls.snippet_node

local s = function(...)
  local snip = ls.s(...)
  ls.add_snippets('tex', { snip })
  -- table.insert(getfenv(2).ls_file_snippets, snip)
end

local r = ls.restore_node
local f = ls.function_node
local i = ls.insert_node
local t = ls.text_node
local c = ls.choice_node
local d = ls.dynamic_node
local fmta = require('luasnip.extras.fmt').fmta

--- Generate nodes for a simple environment
---@param envname string name of the environment to put as the \begin \end arguments
---@param restore string key for restore key if should be restore snippet (it assures that we define the restore node
---only once using a `_cache` variable)
---@return table environment_snippet_nodes
function M.simple_env_nodes(envname, restore)
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
end

--- Generate nodes for a named environment
--- @param envname string: LaTeX environment name.
---@param restore string key for restore key if should be restore snippet (it assures that we define the restore node
---only once using a `_cache` variable)
---@return table environment_snippet_nodes
function M.named_env_nodes(envname, restore)
  --[[ NOTE:1) we already have the same key ]]
  --[[ NOTE:2) We do not have this key yet ]]
  --[[ NOTE:3) We do not want to restore ]]
  local middle_node = restore and restore == _G.luasnip._cache.named_env_nodes_restore_key and r(2, restore)
    or restore and r(2, restore, i(2))
    or i(2)
  if restore then
    _G.luasnip._cache.named_env_nodes_restore_key = restore
  end
  return fmta(
    [[
  \begin{<>}<>
     <>
  \end{<>}
  ]],
    {
      t(envname),
      sn(1, { m(1, [[.+]], '[', ''), i(1), m(1, [[.+]], ']', '') }), -- optional arguments to environment
      middle_node,
      t(envname),
    }
  )
end

-- TODO: Automatic VISUAL mode snippets <19-03-22> --
--- Generate a snippet that wraps a capture by a command
---@param context table merged with the generated context table `trig` must be specified
---@param command string LaTeX symbol command
---@param opts nil|table merged with the snippet opts table
function M.capture_wrap_snippet(context, command, opts)
  if not context.trig then
    error("context doesn't include a `trig` key which is mandatory", 2)
  end

  local context_default = {
    regTrig = true,
    snippetType = 'autosnippet',
    dscr = command,
    name = context.dscr,
    docstring = command .. [[{]] .. [[{capture}]] .. [[}]] .. [[{0}]],
  }
  context = vim.tbl_extend('keep', context, context_default)

  local body = f(function(_, snip)
    return command .. [[{]] .. snip.captures[1] .. [[}]]
  end)

  s(context, body, opts)
end

--- Creates a function that returns `snippet_node`s based on whether the VISUAL mode was used for filling in or not. The
--- result must be wrapped in a `dynamic_node` in the final VISUAL enabled snippet. For a use case see
--- `simple_command_snippet` in this file.
---@param alternative table Snippet body if we didn't come from VISUAL mode
---@param transform function Takes the VISUAL selection and transforms it into a snippet body
function M.get_visual(alternative, transform)
  local transform_function = transform or function(visual)
    return i(1, visual)
  end
  return function(_, parent)
    pprint(parent.snippet.env)
    if #parent.snippet.env.LS_SELECT_RAW > 0 then
      return sn(nil, transform_function(parent.snippet.env.LS_SELECT_RAW[1]))
    else
      return sn(nil, alternative)
    end
  end
end

-- TODO: Automatically add space after if no space inserted <19-03-22> --
--- Generate a snippet with simple LaTeX command with one parameter
---@param context table merged with the generated context table `trig` must be specified
---@param command string LaTeX symbol command
---@param opts nil|table merged with the snippet opts table
---@param tmpl_opts nil|table
--- - @field visual boolean Whether to define the visual snippet as well
function M.simple_command_snippet(context, command, opts, tmpl_opts)
  if not context.trig then
    error("context doesn't include a `trig` key which is mandatory", 2)
  end

  local context_default = {
    dscr = command,
    name = context.dscr,
    docstring = command .. [[{]] .. [[{1}]] .. [[}]] .. [[{0}]],
    snippetType = 'autosnippet',
  }
  context = vim.tbl_extend('keep', context, context_default)

  local body = fmta(command .. [[{<>}]], i(1))
  local tmlp_opts = tmpl_opts or {}
  body = tmlp_opts.visual
      and d(
        1,
        M.get_visual(body, function(selection)
          return t(command .. [[{]] .. selection .. [[}]])
        end)
      )
    or body

  s(context, body, opts)
end

local no_backslash = require('luasnip.extras.conditions').make_condition(function(line, trig, _)
  return string.sub(line, #line - #trig, #line - #trig) ~= '\\'
end)

--- Generate a snippet with for LaTeX command that is indexed
---@param context table merged with the generated context table `trig` must be specified
---@param command string LaTeX command
---@param indexes table list-like table of indexers
---@param opts nil|table merged with the snippet opts table
function M.indexing_command_snippet(context, command, indexes, opts)
  if not context.trig then
    error("context doesn't include a `trig` key which is mandatory", 2)
  end
  -- NOTE: This regular expression trigger is here to disable expanding after first expansion at the i(1) of indexers
  -- context.trig = context.trig
  indexes = indexes or require('util.snippets.tex.snippet_parts').indexers
  local indexing_snippets = {}
  for _, v in pairs(indexes) do
    table.insert(indexing_snippets, v())
  end
  local context_default = {
    dscr = command .. 'with choice for index',
    name = command,
    regTrig = true,
    docstring = command .. '{index}' .. '{1}{0}',
  }
  context = vim.tbl_extend('keep', context, context_default)
  context.condition = context.condition and context.condition * no_backslash or no_backslash
  s(context, fmta([[<><> <>]], { t(command), c(1, indexing_snippets), i(2) }), opts)
end

--- Generate a snippet with for LaTeX command that is indexed
---@param context table merged with the generated context table `trig` must be specified
---@param opts nil|table merged with the snippet opts table
function M.auto_backslash_snippet(context, opts)
  if not context.trig then
    error("context doesn't include a `trig` key which is mandatory", 2)
  end
  local context_default = {
    dscr = (context.trig .. 'with automatic backslash'),
    name = context.trig,
    docstring = ([[\]] .. context.trig),
    snippetType = 'autosnippet',
  }
  context = vim.tbl_extend('keep', context, context_default)
  s(context, t([[\]] .. context.trig), opts)
end

--- Generate a delimiter snippet
---@param context table merged with the generated context table `trig` must be specified
---@param delimiters table {left_delim, right_delim} where the contents are strings
---@param opts nil|table merged with the snippet opts table
function M.delimiter_snippet(context, delimiters, opts)
  if not context.trig then
    error("context doesn't include a `trig` key which is mandatory", 2)
  end
  local context_default = {
    dscr = context.name and (context.name .. ' delimiters'),
    docstring = delimiters[1] .. [[{1}]] .. delimiters[2],
    wordTrig = true,
  }
  context = vim.tbl_extend('keep', context, context_default)
  s(context, fmta([[<> <> <>]], { t(delimiters[1]), i(1), t(delimiters[2]) }), opts)
end

--- Generate a symbol snippet
---@param context table merged with the generated context table `trig` must be specified
---@param command string LaTeX symbol command
---@param opts nil|table merged with the snippet opts table
function M.symbol_snippet(context, command, opts)
  if not context.trig then
    error("context doesn't include a `trig` key which is mandatory", 2)
  end
  local context_default = {
    dscr = command,
    name = command:gsub([[\]], command),
    snippetType = 'autosnippet',
    docstring = (command .. [[{0}]]),
    wordTrig = false,
  }
  context = vim.tbl_extend('keep', context, context_default)
  s(context, t(command), opts)
end

--- Generate a snippet with for LaTeX command that is indexed
---@param context table merged with the generated context table `trig` must be specified
---@param opts nil|table merged with the snippet opts table
function M.auto_backslash_argument_command_snippet(context, opts)
  if not context.trig then
    error("context doesn't include a `trig` key which is mandatory", 2)
  end
  local context_default = {
    dscr = context.trig .. 'with automatic backslash',
    name = context.trig,
    docstring = [[\]] .. context.trig .. [[{{1}}{0}]],
  }
  context = vim.tbl_extend('keep', context, context_default)
  s(context, fmta([[\]] .. context.trig .. [[{<>}]], i(1)), opts)
end

return M
