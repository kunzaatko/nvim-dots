local M = {}
local Path = require 'plenary.path'
local scandir = require 'plenary.scandir'

-- TODO: Use `fs.root` for this <kunzaatko martinkunz@email.cz>
--- Find the root of the project
---@param markerfiles string|string[] A list of files that mark a root folder for the current project
---@param opts table|nil options for the root finding
---- hidden boolean search in hidden files (default: true)
---@return Path root of the project
function M.project_root(markerfiles, opts)
  opts = vim.tbl_extend('keep', opts or {}, { hidden = true })
  local markerlist = type(markerfiles) == 'table' and markerfiles or { markerfiles }
  local filepath = Path:new(vim.api.nvim_buf_get_name(0))

  assert(filepath:is_file(), 'Function can be called only from a file buffer')
  local parent = filepath:parent()
  while parent.filename ~= '/' do
    local dircontent = scandir.ls(parent.filename, { hidden = opts.hidden })
    for _, f in pairs(markerlist) do
      for _, c in pairs(dircontent) do
        if string.find(c, f) then
          return parent
        end
      end
    end
    parent = parent:parent()
  end
  error 'Could not find project root'
end

return M
