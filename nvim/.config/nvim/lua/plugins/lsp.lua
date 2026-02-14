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
				ensure_installed = {
					"pyright",
					"lua_ls",
					"texlab",
					"clangd",
					"ts_ls",
					"eslint",
					"tailwindcss",
					"html",
					"cssls",
					"jsonls",
					"emmet_ls",
				},
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

			-----------------------------
			-- TEXLAB = Fehlermeldungen --
			-----------------------------
			vim.lsp.config("texlab", {
				settings = {
					texlab = {
						build = {
							executable = "latexmk",
							args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
							onSave = true, -- ⬅ Kompiliert beim Speichern
						},
						chktex = {
							onOpenAndSave = true, -- Fehlermeldungen
							onEdit = true,
						},
					},
				},
			})

			----------------------
			-- CLANGD = C / C++ --
			----------------------
			vim.lsp.config("clangd", {
				on_attach = function(client, bufnr)
					-- clangd kann formatieren → optional deaktivieren,
					-- falls du clang-format extern nutzen willst
					-- client.server_capabilities.documentFormattingProvider = false

					on_attach(client, bufnr)
				end,
				cmd = {
					"clangd",
					"--background-index",
					"--clang-tidy",
					"--completion-style=detailed",
					"--header-insertion=iwyu",
				},
				filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
			})

			-------------------------
			-- TS/JS = React / Node --
			-------------------------
			vim.lsp.config("ts_ls", {
				on_attach = function(client, bufnr)
					-- Formatting lieber Prettier/null-ls überlassen
					client.server_capabilities.documentFormattingProvider = false
					client.server_capabilities.documentRangeFormattingProvider = false
					on_attach(client, bufnr)
				end,
				settings = {
					-- optional: etwas “freundlicher” fürs Frontend
					completions = {
						completeFunctionCalls = true,
					},
				},
			})

			--------------
			-- ESLint LSP --
			--------------
			vim.lsp.config("eslint", {
				on_attach = function(client, bufnr)
					on_attach(client, bufnr)
				end,
			})

			----------------
			-- TailwindCSS --
			----------------
			vim.lsp.config("tailwindcss", {
				on_attach = on_attach,
				filetypes = {
					"html",
					"css",
					"scss",
					"javascript",
					"javascriptreact",
					"typescript",
					"typescriptreact",
					"svelte",
					"vue",
				},
			})

			---------
			-- HTML --
			---------
			vim.lsp.config("html", { on_attach = on_attach })

			--------
			-- CSS --
			--------
			vim.lsp.config("cssls", { on_attach = on_attach })

			---------
			-- JSON --
			---------
			vim.lsp.config("jsonls", { on_attach = on_attach })

			----------
			-- Emmet --
			----------
			vim.lsp.config("emmet_ls", {
				on_attach = on_attach,
				filetypes = { "html", "css", "scss", "javascriptreact", "typescriptreact" },
			})

			-------------------------
			-- Server aktivieren ----
			-------------------------
			vim.lsp.enable("pyright")
			vim.lsp.enable("jedi_language_server")
			vim.lsp.enable("texlab")
			vim.lsp.enable("clangd")
			vim.lsp.enable("ts_ls")
			vim.lsp.enable("eslint")
			vim.lsp.enable("tailwindcss")
			vim.lsp.enable("html")
			vim.lsp.enable("cssls")
			vim.lsp.enable("jsonls")
			vim.lsp.enable("emmet_ls")

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
			-- FORMAT ON SAVE (BLACK + ISORT via null-ls) ----
			--------------------------------------------------
			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*.py",
				callback = function(event)
					vim.lsp.buf.format({
						bufnr = event.buf,
						timeout_ms = 3000,
						filter = function(client)
							-- Nur null-ls formatiert
							return client.name == "null-ls"
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
							return client.name == "null-ls"
						end,
					})
				end,
			})

			----------------------------
			-- FORMAT ON SAVE (Latex) --
			----------------------------
			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*.tex",
				callback = function()
					vim.lsp.buf.format({ timeout_ms = 3000 })
				end,
			})

			----------------
			-- FORMAT C++ --
			----------------
			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = { "*.c", "*.cpp", "*.h", "*.hpp" },
				callback = function()
					vim.lsp.buf.format({ timeout_ms = 3000 })
				end,
			})

			------------------------
			-- FORMAT TS/JS/React --
			------------------------
			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = { "*.js", "*.jsx", "*.ts", "*.tsx", "*.json", "*.css", "*.scss", "*.md" },
				callback = function(event)
					vim.lsp.buf.format({
						bufnr = event.buf,
						timeout_ms = 3000,
						filter = function(client)
							return client.name == "null-ls"
						end,
					})
				end,
			})
		end,
	},
}
