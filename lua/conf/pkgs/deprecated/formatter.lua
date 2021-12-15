-- yaml, javascript, json, html, css, PHP, markdown, typescript,
-- toml (added from https://github.com/bd82/toml-tools/tree/master/packages/prettier-plugin-toml)
local function prettier()
  return {
    exe = 'prettier',
    args = { '--stdin-filepath', vim.api.nvim_buf_get_name(0), '--single-quote' },
    stdin = true,
  }
end

-- c / cxx
local function clangformat()
  return {
    exe = 'clang-format',
    args = { '-assume-filename=' .. vim.fn.expand('%:t') },
    stdin = true,
  }
end

-- bash
local function shfmt()
  return { exe = 'shfmt', args = { '-sr', '-i 4', '-ci', '-s' }, stdin = true }
end

-- rust
local function rustfmt()
  return { exe = 'rustfmt', args = { '--emit=stdout' }, stdin = true }
end

-- LaTeX
local function latexindent()
  return {
    exe = 'latexindent',
    args = { '--logfile=./target/.latex_indent.log' },
    stdin = true,
  }
end

-- lua
local function luaformat()
  return { exe = 'lua-format', stdin = true }
end

-- python
local function isort()
  return { exe = 'isort', args = { '-', '--quiet' }, stdin = true }
end -- sort imports
local function yapf()
  return { exe = 'yapf', stdin = true }
end -- google python formatter

require'formatter'.setup(
  {
    logging = false,
    filetype = {
      yaml = { prettier },
      css = { prettier },
      markdown = { prettier },
      toml = { prettier },
      javascript = { prettier },
      json = { prettier },
      html = { prettier },
      c = { clangformat },
      cpp = { clangformat },
      rust = { rustfmt },
      python = { isort, yapf },
      tex = { latexindent },
      lua = { luaformat },
      sh = { shfmt },
      bash = { shfmt },
    },
  }
)

