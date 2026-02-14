return {
	---------------------------------------
	-- nvim-cmp (Completion Engine)
	---------------------------------------
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp", -- LSP-Completion
			"hrsh7th/cmp-buffer", -- Buffer-Wörter
			"hrsh7th/cmp-path", -- Dateipfade
			"hrsh7th/cmp-cmdline", -- : Commands
			"L3MON4D3/LuaSnip", -- Snippet Engine
			"saadparwaiz1/cmp_luasnip", -- Snippet Source für cmp
			"rafamadriz/friendly-snippets", -- große Sammlung Snippets
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")

			-- Snippets laden
			require("luasnip.loaders.from_vscode").lazy_load()

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},

				mapping = cmp.mapping.preset.insert({
					["<C-Space>"] = cmp.mapping.complete(),
					["<CR>"] = cmp.mapping({
						i = function(fallback)
							if cmp.visible() and cmp.get_selected_entry() then
								cmp.confirm({ select = false }) -- nur bestätigen wenn explizit ausgewählt
							else
								fallback() -- normalen Zeilenumbruch
							end
						end,
						s = function(fallback) -- wenn im Select-Modus (z.B. snippets)
							if cmp.visible() and cmp.get_selected_entry() then
								cmp.confirm({ select = false })
							else
								fallback()
							end
						end,
						c = function(fallback) -- Command-Line: Enter soll Befehl ausführen,
							-- aber wenn ein Eintrag selektiert ist, darf der bestätigt werden
							if cmp.visible() and cmp.get_selected_entry() then
								cmp.confirm({ select = true })
							else
								fallback() -- führt die Command (z.B. :q) wie gewohnt aus
							end
						end,
					}),
					["<C-e>"] = cmp.mapping.abort(),

					-- Tab = next completion / next snippet
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),

					-- Shift-Tab = previous
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),

				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "path" },
					{ name = "buffer" },
				}),
			})

			-- Completion im Command-Line Modus (: …)
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "path" },
					{ name = "cmdline" },
				},
			})
		end,
	},
}
