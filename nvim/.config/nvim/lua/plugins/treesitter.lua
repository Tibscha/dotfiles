return {
	"nvim-treesitter/nvim-treesitter",
	branch = "master",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		local config = require("nvim-treesitter.configs")
		config.setup({
			ensure_installed = {
				"lua",
				"python",
				"markdown",
				"markdown_inline",
--				"latex",
			},
			highlight = { enable = true },
			indent = { enable = true },
		})
	end,
}
