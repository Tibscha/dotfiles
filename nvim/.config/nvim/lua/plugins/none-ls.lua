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
				args = { "-q", "-f%l:%c:%d:%k:%m\n", "-" },
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
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.black,
				null_ls.builtins.formatting.isort,
				latexindent,
				chktex, -- eigene Quelle
			},
		})

		vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
	end,
}
