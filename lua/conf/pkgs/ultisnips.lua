-- Snippets variables
vim.g.snips_author = "kunzaatko"
vim.g.snips_email = "martinkunz@email.cz"
vim.g.snips_github = "https://github.com/kunzaatko"
-- UltiSnips
vim.g.UltiSnipsSnippetDirectories = {'/home/kunzaatko/.local/share/nvim/snips'} -- this ensures that snippets directories are not recursively searched
vim.g.UltiSnipsEnableSnipMate = 0 -- only look for UltiSnips snippets
vim.g.UltiSnipsExpandTrigger = '<c-l>' -- overwrites escaping to insert mode when insertmode option is set
