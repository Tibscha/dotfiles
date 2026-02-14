return {
	-- Copilot "Engine" (Lua)
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		opts = {
			suggestion = { enabled = true }, -- ghost text
			panel = { enabled = false },
		},
	},

	-- Copilot Chat UI
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{ "nvim-lua/plenary.nvim", branch = "master" },
			"zbirenbaum/copilot.lua",
		},
		build = "make tiktoken",
		opts = {
			window = {
				layout = "vertical",
				width = 0.30,
			},
			-- hier kannst du später model/behavior etc. setzen
		},

		-- sinnvolle Keymaps
		keys = {
			{ "<leader>at", "<cmd>CopilotChatToggle<cr>", desc = "AI: Toggle Chat" },
			{ "<leader>ao", "<cmd>CopilotChatOpen<cr>", desc = "AI: Open Chat" },
			{ "<leader>aq", "<cmd>CopilotChatClose<cr>", desc = "AI: Close Chat" },

			-- Visual mode: markiere Code, dann:
			{ "<leader>ae", "<cmd>CopilotChatExplain<cr>", mode = "v", desc = "AI: Explain selection" },
			{ "<leader>af", "<cmd>CopilotChatFix<cr>", mode = "v", desc = "AI: Fix selection" },
			{ "<leader>ar", "<cmd>CopilotChatReview<cr>", mode = "v", desc = "AI: Review selection" },
			{ "<leader>ad", "<cmd>CopilotChatDocs<cr>", mode = "v", desc = "AI: Docs for selection" },
			{ "<leader>ap", "<cmd>CopilotChatTests<cr>", mode = "v", desc = "AI: Tests for selection" },
		},
	},
	config = function(_, opts)
		vim.opt.splitright = true
		require("CopilotChat").setup(opts)
	end,
}
