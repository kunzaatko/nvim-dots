lua << EOF
    local window = {vim.wo, vim.o}
    local opt = require"utils".opt

    opt ('conceallevel', 1, window)
    vim.g.tex_conceal='abdmg' -- no s... do not conceal sub/sup scripts
EOF
