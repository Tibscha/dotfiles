return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-tree/nvim-web-devicons", -- optional, but recommended
	},
	filesystem = {
		follow_current_file = { enabled = true },
		hijack_netrw_behavior = "open_default",
		use_libuv_file_watcher = true, -- <─ 🔥 live refresh bei Dateisystem-Änderungen
	},
	config = function()
		vim.keymap.set("n", "<leader>n", ":Neotree toggle<CR>", { desc = "Toggle Neo-tree" })
		vim.keymap.set("n", "<leader>th", "Neotree toggle show_hidden=true<CR>")
	end,
}
