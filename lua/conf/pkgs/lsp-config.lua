local lspconfig = require 'lspconfig'
local on_attach = function(_, bufnr)
  -- {{{
  local map_loc = vim.api.nvim_buf_set_keymap

  map_loc(bufnr, 'n', '<c-]>', "<Cmd>lua vim.lsp.buf.definition()<CR>",
          {noremap = true, silent = true})
  map_loc(bufnr, 'n', 'K', "<Cmd>lua vim.lsp.buf.hover()<CR>",
          {noremap = true, silent = true})
  map_loc(bufnr, 'n', 'gD', "<Cmd>lua vim.lsp.buf.implementation()<CR>",
          {noremap = true, silent = true})
  map_loc(bufnr, 'n', '<c-k>', "<Cmd>lua vim.lsp.buf.signature_help()<CR>",
          {noremap = true, silent = true})
  map_loc(bufnr, 'n', '1gD', "<Cmd>lua vim.lsp.buf.type_definition()<CR>",
          {noremap = true, silent = true})
  map_loc(bufnr, 'n', 'gr', "<Cmd>lua vim.lsp.buf.references()<CR>",
          {noremap = true, silent = true})
  map_loc(bufnr, 'n', 'g0', "<Cmd>lua vim.lsp.buf.document_symbol()<CR>",
          {noremap = true, silent = true})
  map_loc(bufnr, 'n', 'gW', "<Cmd>lua vim.lsp.buf.workspace_symbol()<CR>",
          {noremap = true, silent = true})
  map_loc(bufnr, 'n', 'gd', "<Cmd>lua vim.lsp.buf.declaration()<CR>",
          {noremap = true, silent = true})
  map_loc(bufnr, 'n', 'ga', "<Cmd>lua vim.lsp.buf.code_action()<CR>",
          {noremap = true, silent = true})

  -- Goto previous/next diagnostic warning/error
  map_loc(bufnr, 'n', 'g[', "<Cmd>lua vim.lsp.diagnostic.goto_prev()<CR>",
          {noremap = true, silent = true})
  map_loc(bufnr, 'n', 'g]', "<Cmd>lua vim.lsp.diagnostic.goto_next()<CR>",
          {noremap = true, silent = true})
end -- }}}

local servers = {"bashls", "texlab", "ccls", "rust_analyzer", "vimls"}
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {on_attach = on_attach, flags = {debounce_text_changes = 150}}
end

lspconfig.julials.setup {
  settings = {julia = {format = {indent = 2}}},
  on_attach = on_attach,
  on_new_config = function(new_config, _)
    local server_path = "/home/kunzaatko/.julia/packages/LanguageServer/y1ebo/src"
    local cmd = {
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

lspconfig.pyright.setup {
  settings = {python = {formatting = {provider = 'yapf'}}},
  on_attach = on_attach,
}

lspconfig.sumneko_lua.setup {
  on_attach = on_attach,
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
