return {
	"nvimtools/none-ls.nvim",
	config = function()
		local null_ls = require("null-ls")

		-- MANUELLE chktex-Quelle (weil aus den builtins entfernt)
		local chktex = {
			name = "chktex",
			method = null_ls.methods.DIAGNOSTICS,
			filetypes = { "tex" },
			generator = null_ls.generator({
				command = "chktex",
				args = { "-q", "-f%l:%c:%d:%k:%m\n", "-n13", "-" },
				to_stdin = true,
				from_stderr = false,
				format = "raw",
				on_output = function(line)
					-- Erwartetes Format:
					-- line:col:errorcode:severity:message
					local row, col, err, sev, msg = line:match("(%d+):(%d+):(%d+):(%d+):(.*)")
					if not row then
						return nil
					end

					return {
						row = tonumber(row),
						col = tonumber(col),
						message = msg,
						severity = (tonumber(sev) == 0) and vim.diagnostic.severity.WARN
							or vim.diagnostic.severity.ERROR,
						source = "chktex",
					}
				end,
			}),
		}

		local null_ls = require("null-ls")

		local latexindent = {
			name = "latexindent",
			method = null_ls.methods.FORMATTING,
			filetypes = { "tex" },
			generator = null_ls.generator({
				command = "latexindent",
				args = { "-m", "-y=defaultIndent: '  '" }, -- Beispielargumente, kann angepasst werden
				to_stdin = true,
			}),
		}

		null_ls.setup({
			debug = true,
			sources = {
				-- Lua
				null_ls.builtins.formatting.stylua,

				-- Python
				null_ls.builtins.formatting.black.with({
					extra_args = { "--line-length", "80" },
				}),
				null_ls.builtins.formatting.isort,

				-- Frontend (Vite + React + TS)
				null_ls.builtins.formatting.prettier.with({
					filetypes = {
						"javascript",
						"javascriptreact",
						"typescript",
						"typescriptreact",
						"json",
						"css",
						"scss",
						"html",
						"markdown",
					},
				}),

				-- ESLint: erstmal nur diagnostics (stabil)
				null_ls.builtins.diagnostics.eslint_d,
				null_ls.builtins.code_actions.eslint_d,

				-- Latex
				latexindent,
				chktex,

				-- C/C++
				null_ls.builtins.formatting.clang_format.with({
					filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
					extra_args = { "--style=file" },
				}),
			},
		})

		vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = { "*.c", "*.cpp", "*.h", "*.hpp" },
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
}
