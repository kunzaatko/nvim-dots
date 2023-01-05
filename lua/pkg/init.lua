-- TODO: Add more mappings to '<leader>' with which-key <16-01-22, kunzaatko> --
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
    -- TODO: Is this necessary anymore? <29-10-22>
    config = function()
      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('Packer', {}),
        pattern = 'packer',
        desc = 'Do not use spelling in Packer window',
        callback = function()
          vim.opt_local.spell = false
        end,
      })
    end,
  },
}

for _, mod in ipairs {
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
  'pkg.integrations',
} do
  for _, spec in ipairs(require(mod)) do
    table.insert(plugins, spec)
  end
end

local packer = require 'packer'
return packer.startup {
  plugins,
  config = {
    display = {
      open_fn = function()
        return require('packer.util').float { border = 'rounded' }
      end,
    },
    profile = {
      enable = true,
      threshold = 0.0001,
    },
    git = {
      clone_timeout = 300,
      subcommands = {
        update = 'pull --rebase',
      },
    },
    auto_clean = true,
    compile_on_sync = true,
    auto_reload_compiled = false,
  },
}
