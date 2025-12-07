return {
	-- Mason
	{
		"mason-org/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},

	-- Mason + lspconfig bridge (installiert Server)
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = { "mason-org/mason.nvim" },
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "pyright", "lua_ls" },
				automatic_installation = true,
			})
		end,
	},

	-- LSP (neue API)
	{
		"neovim/nvim-lspconfig",
		config = function()
			---------------------------------------------------
			-- Allgemeine LSP-Keybindings **wenn Server aktiv**
			---------------------------------------------------
			local on_attach = function(client, bufnr)
				local function bufmap(mode, lhs, rhs)
					vim.keymap.set(mode, lhs, rhs, { buffer = bufnr })
				end

				bufmap("n", "K", vim.lsp.buf.hover)
				bufmap("n", "gd", vim.lsp.buf.definition)
				bufmap({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action)
			end

			---------------------------------------
			-- PYRIGHT = Typen, Fehler, Imports ----
			---------------------------------------
			vim.lsp.config("pyright", {
				on_attach = function(client, bufnr)
					-- Pyright liefert KEIN Hover, KEIN SignatureHelp
					client.server_capabilities.hoverProvider = false
					client.server_capabilities.signatureHelpProvider = false
					on_attach(client, bufnr)
				end,
				settings = {
					python = {
						analysis = {
							typeCheckingMode = "basic",
							diagnosticMode = "workspace",
							useLibraryCodeForTypes = true,
						},
					},
				},
			})

			-----------------------------
			-- JEDI = Hover / Docstring --
			-----------------------------
			vim.lsp.config("jedi_language_server", {
				on_attach = function(client, bufnr)
					client.server_capabilities.diagnosticProvider = false -- Pyright liefert Diagnostik
					on_attach(client, bufnr)
				end,
				init_options = {
					diagnostics = { enable = false },
				},
			})

			-------------------------
			-- Server aktivieren ----
			-------------------------
			vim.lsp.enable("pyright")
			vim.lsp.enable("jedi_language_server")

			------------------------------
			-- Diagnostics anzeigen -----
			------------------------------
			vim.diagnostic.config({
				virtual_text = { spacing = 2, prefix = "●" },
				signs = true,
				underline = true,
				update_in_insert = false,
				severity_sort = true,
			})

			--------------------------------------------------
			-- FORMAT ON SAVE (BLACK + ISORT via none-ls) ----
			--------------------------------------------------
			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*.py",
				callback = function(event)
					vim.lsp.buf.format({
						bufnr = event.buf,
						timeout_ms = 3000,
						filter = function(client)
							-- Nur none-ls formatiert
							return client.name == "none-ls"
						end,
					})
				end,
			})

			---------------------------------------------------------
			-- PYRIGHT ORGANIZE IMPORTS (entfernt unused + sortiert) -
			---------------------------------------------------------
			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*.py",
				callback = function(event)
					vim.lsp.buf.format({
						bufnr = event.buf,
						timeout_ms = 3000,
						filter = function(client)
							return client.name == "null-ls" -- hier ist der korrekte Name
						end,
					})
				end,
			})
		end,
	},
}
