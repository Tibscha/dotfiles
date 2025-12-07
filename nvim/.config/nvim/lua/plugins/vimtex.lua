return {
	"lervag/vimtex",
	lazy = false, -- we don't want to lazy load VimTeX
	-- tag = "v2.15", -- uncomment to pin to a specific release
	init = function()
		vim.g.vimtex_view_method = "zathura"
		vim.g.vimtex_view_forward_search_on_start = 1
		vim.cmd([[
      autocmd BufWritePost *.tex silent! VimtexCompile
    ]])
		-- VimTeX configuration goes here, e.g.
		-- vim.g.vimtex_view_method = "zathura"
	end,
}
