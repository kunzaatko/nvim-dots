return {
  'lervag/vimtex',
  ft = 'tex',
  -- enabled = false,
  config = function()
    vim.g.vimtex_fold_enabled = 0 -- foldexpr function for folds
    -- vim.g.vimtex_fold_manual = 1 -- only fold on demand
    vim.g.vimtex_imaps_enabled = 0
    vim.g.vimtex_quickfix_autoclose_after_keystrokes = 1 -- close the quickfix if the cursor is moved after compiling
    -- NOTE: if set to 1 it copies the output after every compilation instead of the last one
    vim.g.vimtex_view_use_temp_files = 2 -- ensures, that the PDF does not update after a failed compilation
    vim.g.vimtex_view_automatic = 1 -- for mklatex it has to be set only if the use_temp_files is non-zero
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
  end,
}
