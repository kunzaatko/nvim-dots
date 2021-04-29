local lsp = require 'lspconfig'
local attach_mappings = function()
  require "map.pkgs.lsp-mappings"
end

lsp.bashls.setup {on_attach = attach_mappings()}

lsp.texlab.setup {on_attach = attach_mappings()}

lsp.ccls.setup {on_attach = attach_mappings()}

lsp.rust_analyzer.setup {on_attach = attach_mappings()}

lsp.vimls.setup {on_attach = attach_mappings()}

lsp.julials.setup {
  settings = {julia = {format = {indent = 2}}},
  on_attach = attach_mappings(),
  on_new_config = function(new_config, new_root_dir)
    server_path = "/home/kunzaatko/.julia/packages/LanguageServer/y1ebo/src"
    cmd = {
      "julia",
      "--project=" .. server_path,
      "--startup-file=no",
      "--history-file=no",
      "-e",
      [[
          using Pkg;
          Pkg.instantiate()
          using LanguageServer; using SymbolServer;
          depot_path = get(ENV, "JULIA_DEPOT_PATH", "")
          project_path = dirname(something(Base.current_project(pwd()), Base.load_path_expand(LOAD_PATH[2])))
          # Make sure that we only load packages from this environment specifically.
          @info "Running language server" env=Base.load_path()[1] pwd() project_path depot_path
          server = LanguageServer.LanguageServerInstance(stdin, stdout, project_path, depot_path);
          server.runlinter = true;
          run(server);
        ]],
    };
    new_config.cmd = cmd
  end,
}

lsp.pyright.setup {
  settings = {python = {formatting = {provider = 'yapf'}}},
  on_attach = attach_mappings(),
}

lsp.sumneko_lua.setup {
  on_attach = attach_mappings(),
  cmd = {'lua-language-server'},
  settings = {
    Lua = {
      diagnostics = {globals = {'vim'}},
      runtime = {version = 'LuaJIT', path = vim.split(package.path, ';')},
      workspace = {
        library = {
          [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
        },
      },
    },
  },
}
