local util = require 'util'

local language_server_jl = [[
# Load LanguageServer.jl: attempt to load from ~/.julia/environments/nvim-lspconfig
# with the regular load path as a fallback
ls_install_path = joinpath(
    get(DEPOT_PATH, 1, joinpath(homedir(), ".julia")),
    "environments", "nvim-lspconfig"
)
pushfirst!(LOAD_PATH, ls_install_path)
using LanguageServer, SymbolServer, StaticLint
popfirst!(LOAD_PATH)
depot_path = get(ENV, "JULIA_DEPOT_PATH", "")
project_path = let
    dirname(something(
        ## 1. Finds an explicitly set project (JULIA_PROJECT)
        Base.load_path_expand((
            p = get(ENV, "JULIA_PROJECT", nothing);
            p === nothing ? nothing : isempty(p) ? nothing : p
        )),
        ## 2. Look for a Project.toml file in the current working directory,
        ##    or parent directories, with $HOME as an upper boundary
        Base.current_project(),
        ## 3. First entry in the load path
        get(Base.load_path(), 1, nothing),
        ## 4. Fallback to default global environment,
        ##    this is more or less unreachable
        Base.load_path_expand("@v#.#"),
    ))
end
@info "Running language server" VERSION pwd() project_path depot_path
server = LanguageServer.LanguageServerInstance(stdin, stdout, project_path, depot_path)
server.runlinter = true
run(server)
]]

---@diagnostic disable-next-line: undefined-doc-name
---@type  vim.lsp.Config
local opts = {
  filetypes = { 'julia' },
  root_markers = { 'Project.toml', 'JuliaProject.toml', '.git' },
  cmd = {
    'env',
    'LD_LIBRARY_PATH=/usr/lib/julia',
    'julia',
    '--startup-file=no',
    '--history-file=no',
    '-e',
    language_server_jl,
  },
  on_attach = function()
    vim.api.nvim_create_user_command('LspJuliaUpdate', function()
      util.terminal.oneshot(
        [[fish -c "julia --project=~/.julia/environments/nvim-lspconfig -e \"using Pkg; Pkg.update()\""]],
        {
          interactive = false,
          win = { position = 'right' },
        }
      )
    end, {
      desc = 'Update the `LanguageServer`, `SymbolServer` and `StaticLint` in the `nvim-lspconfig` environment',
    })
  end,
}

return opts
