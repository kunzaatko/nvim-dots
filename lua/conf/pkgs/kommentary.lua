local map = vim.api.nvim_set_keymap
local config = require('kommentary.config')

config.add_keymap("n", "kommentary_line_force_singles", config.context.line, {},
                  "kommentary.toggle_comment_singles")
config.add_keymap("n", "kommentary_motion_force_singles", config.context.init,
                  {expr = true}, "kommentary.toggle_comment_singles")
config.add_keymap("v", "kommentary_visual_force_singles", config.context.visual, {},
                  "kommentary.toggle_comment_singles")

-- motion
map('n', '<leader>K', '<Plug>kommentary_motion_force_singles', {})
map('n', '<leader>k', '<Plug>kommentary_motion_default', {})

-- line
map('n', '<leader>kk', '<plug>kommentary_line_force_singles', {})
map('n', '<leader>kk', '<plug>kommentary_line_default', {})

-- visual
map('v', '<leader>K', '<Plug>kommentary_visual_force_singles', {})
map('v', '<leader>k', '<Plug>kommentary_visual_default', {})
