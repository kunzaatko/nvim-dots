-- TODO: Add more mappings to '<leacer>' with which-key <16-01-22, kunzaatko> --
-- TODO: Better way how to manage dependencies. Especially for lsp parts <16-01-22, kunzaatko> --
-- TODO: Auto document into the README.file <16-01-22, kunzaatko> --
-- TODO: More contrast color between windows (fillchars separators) <16-01-22, kunzaatko> --

local plugins = {
  -- manage packer as optional plug-in
  {
    'wbthomason/packer.nvim',
    cmd = {
      'PackerCompile',
      'PackerClean',
      'PackerInstall',
      'PackerUpdate',
      'PackerSync',
      'PackerLoad',
      'PackerProfile',
    },
    opt = true,
    setup = function()
      -- NOTE: Without this, the commands would not have a spec to act upon <kunzaatko> --
      require 'pkg'
    end,
    config = function()
      -- TODO: On v0.7 change to lua API autocommand <10-03-22, kunzaatko> --
      vim.cmd [[autocmd FileType packer lua vim.opt_local.spell = false]]
    end,
  },
}

for _, mod in
  ipairs {
    'pkg.essential',
    'pkg.languages',
    'pkg.lsp',
    'pkg.aesthetics',
    'pkg.snippets',
    'pkg.movement',
    'pkg.git',
    'pkg.terminal',
    'pkg.environments',
    'pkg.sessions',
    'pkg.editting',
    'pkg.libraries',
  }
do
  for _, spec in ipairs(require(mod)) do
    table.insert(plugins, spec)
  end
end

local packer = require 'packer'
return packer.startup {
  plugins,
  config = {
    auto_reload_compiled = false,
    profile = { enable = true },
  },
}
