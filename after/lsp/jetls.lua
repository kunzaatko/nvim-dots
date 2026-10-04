---@brief
---
--- https://github.com/aviatesk/JETLS.jl
---
--- For JETLS installation: Use the Julia Apps helper:
--- ```sh
--- julia -e 'using Pkg; Pkg.Apps.add(; url="https://github.com/aviatesk/JETLS.jl", rev="release")'
--- ```
--- To update it, run the same command again

---@diagnostic disable-next-line: undefined-doc-name
---@type vim.lsp.Config
return {
  cmd = {
    'env',
    'LD_LIBRARY_PATH=/usr/lib/julia',
    'jetls',
    'serve',
  },
  filetypes = { 'julia' },
  root_markers = { 'Project.toml' },
}
