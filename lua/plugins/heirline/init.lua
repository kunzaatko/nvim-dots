_G.HEIRLINE_CONFIG_HOME = 'plugins.heirline.config'

-- TODO: Move my configuration to another plugin <19-04-23>
-- TODO: Make the configuration clickable <19-04-23>
-- TODO: Add heirline components from NvChad/NvChad <12-01-23>
-- TODO: Customize the fold column <19-04-23>
-- TODO: Make a delimited list component combinator that takes a list of components <kunzaatko>
-- TODO: Make a generic combinator component for the front of the statusline and the end of a statusline <14-05-23>
-- TODO: Move provider functions to and functions that are generic enough to util <14-05-23>

return {
  'rebelot/heirline.nvim',
  name = 'heirline',
  event = 'UIEnter',
  dependencies = { { 'kyazdani42/nvim-web-devicons', name = 'devicons' }, { 'rktjmp/lush.nvim', name = 'lush' } },
  config = function()
    local statusline = require(HEIRLINE_CONFIG_HOME)
    require('heirline').setup { statusline = statusline }
  end,
}
