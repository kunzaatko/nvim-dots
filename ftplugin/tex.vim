lua << EOF
    local map = vim.api.nvim_set_keymap
    local MUtils = _G.MUtils
    local Job = require"plenary.job"
    local path = require"plenary.path"

    vim.wo.conceallevel = 1
    vim.g.tex_conceal = 'abdmg' -- no s... do not conceal sub/sup scripts

    -- TODO: Some REGEX for adding label and caption at the same time for ex. (some fig (This fig shows a function), or: some fig: this fig shows a function [a sin fucntion in the functions section]) <07-11-21, kunzaatko> "
    MUtils.inkscape_figures_create = function(fig_name)
        local figs_root = path.new(vim.b.vimtex.root):joinpath("figures")
        local LaTeX_template = Job:new({
            command = 'inkscape-figures',
            args = {'create',fig_name, figs_root.filename},
        }):sync()

        vim.api.nvim_put(LaTeX_template, "l", false, true)
        vim.api.nvim_del_current_line()
    end

    MUtils.inkscape_figures_edit = function()
        local figs_root = path.new(vim.b.vimtex.root):joinpath("figures")
        Job:new({
            command = 'inkscape-figures',
            args = {'edit', figs_root.filename}
        }):start()
    end

    map('i', '<C-f>', '<Cmd>lua _G.MUtils.inkscape_figures_create(vim.api.nvim_get_current_line()) <CR>', {noremap=true, silent = true})
    map('n', '<C-f>', '<Cmd>lua _G.MUtils.inkscape_figures_edit() <CR>', {noremap=true, silent=true})
EOF
