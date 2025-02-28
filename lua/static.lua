_G.static = {}
-- TODO: Consider adding through neovim sign interface <11-05-23>
-- FIX: Make these from codicon <11-05-23>
-- FIX: CamelCase because of signs in  diagnostics config
local icons = {}
icons = {
  find = '',
  projects = '',
  terminal = '',
  macro_recording = '',
  spellcheck = '',
  ActiveLSP = '',
  ActiveTS = '',
  ellipsis = '…',
  ai = '',
  snippets = '',
  sessions = '󰒲',
}

icons.arrow = {
  left = '',
  right = '',
}

icons.dap = {
  --     
  breakpoint = '',
  breakpoint_condition = '',
  breakpoint_rejected = '',
  log_point = '.>',
  stopped = '',
}

icons.fold = {
  closed = '',
  opened = '',
  separator = ' ',
}

icons.explorer = {
  folder_closed = '',
  folder_empty = '',
  folder_move = '',
  folder_open = '',
}

icons.comments = {
  todo = '',
  note = '',
  hack = '',
  performance = '',
  bug = '',
}

icons.diagnostics = {
  diagnostics = '', -- ''
  Error = '',
  Warn = '',
  Info = '',
  Hint = '',
}

icons.lsp = { lsp = '', loading_1 = '', loading_2 = '', loading_3 = '', loaded = '' }

icons.git = {
  --  ,  
  fork = '',
  git = '',
  add = '',
  branch = '',
  change = '',
  conflict = '',
  delete = '',
  -- ignored = '◌',
  pull_request = '',
  merge = '',
  renamed = '',
  staged = '✓',
  unstaged = '✗',
  github = '',
  -- untracked = '★',
}

icons.fileformat = {
  dos = '',
  mac = '',
  unix = '',
  unknown = '',
}

icons.statusline = {
  separators = {
    rangle = '⟩',
    langle = '⟨',
  },
  linenumber = '',
  modified = '', -- ,פֿ
  readonly = '', -- ,,,
}

icons.cmp = {
  Env = ' ',
  Buffer = icons.find,
  LSP = icons.lsp.lsp,
  Luasnip = icons.snippets,
  git = icons.git.github,
  latex_symbols = '',
  Ripgrep = '',
  spell = icons.spellcheck,
  ai = icons.ai,
  CodeCompanion = icons.ai,
  path = icons.explorer.folder_open,
  digraphs = '§',
}
icons.undotree = {
  node = '',
}

_G.static.icons = icons

--                                                                
--                                                                          
--                                                                          
--                                                                         
--                                                                          
--                                                                          
--                                                                           
--                                                                           
--                                                                             
--                              
