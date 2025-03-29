_G.static = {}
-- TODO: Consider adding through neovim sign interface <11-05-23>
-- FIX: Make these from codicon <11-05-23>
_G.static.icons = {
  telescope = '',
  link = '',
  rocket = '',
  quote = '',
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
  arrow = {
    left = '',
    right = '',
  },
  dap = {
    --     
    breakpoint = '',
    breakpoint_condition = '',
    breakpoint_rejected = '',
    log_point = '.>',
    stopped = '',
  },
  fold = {
    closed = '',
    opened = '',
    separator = ' ',
  },
  explorer = {
    folder_closed = '',
    folder_empty = '',
    folder_move = '',
    folder_open = '',
  },
  comments = {
    todo = '',
    note = '',
    hack = '',
    performance = '',
    bug = '',
  },
  diagnostics = {
    diagnostics = '', -- ''
    Error = '',
    Warn = '',
    Info = '',
    Hint = '',
  },
  lsp = { lsp = '', loading_1 = '', loading_2 = '', loading_3 = '', loaded = '' },
  git = {
    --  ,  
    label = '',
    issue = '',
    review = '',
    user = '',
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
  },
  fileformat = {
    dos = '',
    mac = '',
    unix = '',
    unknown = '',
  },
  statusline = {
    separators = {
      rangle = '⟩',
      langle = '⟨',
    },
    linenumber = '',
    modified = '', -- ,פֿ
    readonly = '', -- ,,,
  },
  undotree = {
    node = '',
  },
}

static.icons.cmp = {
  Env = ' ',
  Buffer = static.icons.find,
  LSP = static.icons.lsp.lsp,
  Luasnip = static.icons.snippets,
  git = static.icons.git.github,
  latex_symbols = '',
  Ripgrep = '',
  spell = static.icons.spellcheck,
  ai = static.icons.ai,
  CodeCompanion = static.icons.ai,
  path = static.icons.explorer.folder_open,
  digraphs = '§',
  ["Conventional Commits"] = static.icons.git.github
}

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
