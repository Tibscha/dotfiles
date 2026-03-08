return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	opts = {
		filesystem = {
			follow_current_file = { enabled = true },
			hijack_netrw_behavior = "open_default",
			use_libuv_file_watcher = true,
			window = {
				width = 30,
			},
		},
	},
	config = function(_, opts)
		require("neo-tree").setup(opts)
		vim.keymap.set("n", "<leader>m", ":Neotree toggle<CR>", { desc = "Toggle Neo-tree" })
		vim.keymap.set("n", "<leader>th", ":Neotree toggle show_hidden=true<CR>")
	end,
}
