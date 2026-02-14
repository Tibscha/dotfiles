return {
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			require("bufferline").setup({
				options = {
					mode = "buffers", -- wichtig!
					diagnostics = "nvim_lsp",
					separator_style = "slant",
					show_close_icon = false,
				},
			})

			-- Navigation
			vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>")
			vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>")

			-- Direkt springen
			vim.keymap.set("n", "<leader>1", "<cmd>BufferLineGoToBuffer 1<cr>")
			vim.keymap.set("n", "<leader>2", "<cmd>BufferLineGoToBuffer 2<cr>")
			vim.keymap.set("n", "<leader>3", "<cmd>BufferLineGoToBuffer 3<cr>")
			vim.keymap.set("n", "<leader>4", "<cmd>BufferLineGoToBuffer 4<cr>")
			vim.keymap.set("n", "<leader>5", "<cmd>BufferLineGoToBuffer 5<cr>")
			vim.keymap.set("n", "<leader>6", "<cmd>BufferLineGoToBuffer 6<cr>")
			vim.keymap.set("n", "<leader>7", "<cmd>BufferLineGoToBuffer 7<cr>")
			vim.keymap.set("n", "<leader>8", "<cmd>BufferLineGoToBuffer 8<cr>")
			vim.keymap.set("n", "<leader>9", "<cmd>BufferLineGoToBuffer 9<cr>")

			-- Buffer schließen
			vim.keymap.set("n", "<leader>bd", function()
				vim.cmd("bnext")
				vim.cmd("bdelete #")
			end, { desc = "Smart buffer delete" })
		end,
	},
}
