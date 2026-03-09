return {
  "lervag/vimtex",
  lazy = false,
  init = function()
    vim.g.vimtex_view_method = "zathura"
    vim.g.vimtex_view_forward_search_on_start = 1
    vim.cmd([[
      autocmd BufWritePost *.tex silent! VimtexCompile
    ]])
  end,
}
