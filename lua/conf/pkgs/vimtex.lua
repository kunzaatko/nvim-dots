-- TODO: Should find an alternative in tex for the matchparen (vimtex-nf-enhanced-matchparen) as it is said to be slow <04-03-21, kunzaatko>
-- TODO: Consider using texdoc for documentation as per the variable g:vimtex_doc_handlers <05-03-21, kunzaatko> --
-- TODO: Consider using pplatex or pulp for quickfix g:vimtex_quickfix_method <05-03-21, kunzaatko> --
-- TODO: If synctex works normally, then the option g:vimtex_view_zathura_check_libsynctex can be set to 0 <05-03-21, kunzaatko> --
vim.g.vimtex_fold_enabled = 1 -- foldexpr function for folds
vim.g.vimtex_fold_manual = 1 -- only fold on demand
vim.g.vimtex_quickfix_autoclose_after_keystrokes = 1 -- close the quickfix if the cursor is moved after compiling
-- NOTE: if set to 1 it copies the output after every compilation instead of the last one
vim.g.vimtex_view_use_temp_files = 2 -- ensures, that the PDF does not update after a failed compilation
vim.g.vimtex_view_automatic = 1 -- for mklatex it has to be set only if the use_temp_files is nonzero
vim.g.vimtex_view_method = 'zathura'
vim.g.vimtex_compiler_method = 'tectonic'
vim.g.vimtex_compiler_latexmk = {
  build_dir = '',
  callback = 1,
  continuous = 1,
  executable = 'latexmk',
  hooks = {},
  options = {
    '-verbose',
    '-file-line-error',
    '-synctex=1',
    '-interaction=nonstopmode',
    '-shell-escape', -- for running python for the minted package to work
  },
}

vim.g.vimtex_toc_config = { show_help = 0 }
