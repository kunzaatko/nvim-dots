require('neorg').setup {
  load = {
    ['core.defaults'] = {},
    ['core.norg.esupports.metagen'] = {
      config = {
        type = 'empty', -- generate metadata for new empty files or buffers
      },
    },
    ['core.export'] = {},
    ['core.gtd.base'] = {
      config = {
        workspace = 'gtd',
      },
    },
    ['core.norg.completion'] = { config = { engine = 'nvim-cmp' } },
    ['core.norg.qol.toc'] = {},
    ['core.norg.journal'] = {
      config = {
        workspace = 'index',
      },
    },
    ['core.norg.dirman'] = {
      config = {
        workspaces = {
          index = '~/Notes/',
          personal = '~/Notes/personal',
          work = '~/Notes/work/',
          school = '~/Notes/school/',
          blog = '~/Notes/blog',
          gtd = '~/Notes/GTD',
        },
        default_workspace = 'index',
      },
    },
    ['core.norg.concealer'] = {},
  },
}
