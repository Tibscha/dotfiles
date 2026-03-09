local function resolve_vault_path()
  local candidates = {
    "/home/tibor/Documents/Notes/Brain",
    "/home/tibor/Notes/Obsidian",
  }

  if type(vim.env.OBSIDIAN_VAULT) == "string" and vim.env.OBSIDIAN_VAULT ~= "" then
    table.insert(candidates, 1, vim.env.OBSIDIAN_VAULT)
  end

  for _, candidate in ipairs(candidates) do
    if type(candidate) == "string" and candidate ~= "" and vim.fn.isdirectory(candidate) == 1 then
      return vim.fs.normalize(candidate)
    end
  end

  return nil
end

local obsidian_vault = resolve_vault_path()

local function resolve_path(path_or_bufnr)
  if type(path_or_bufnr) == "number" then
    local name = vim.api.nvim_buf_get_name(path_or_bufnr)
    return name ~= "" and vim.fs.normalize(name) or nil
  end

  if type(path_or_bufnr) == "string" and path_or_bufnr ~= "" then
    return vim.fs.normalize(path_or_bufnr)
  end

  return nil
end

local function in_obsidian_vault(path)
  if not obsidian_vault or type(path) ~= "string" or path == "" then
    return false
  end

  local normalized = vim.fs.normalize(path)
  return normalized == obsidian_vault or normalized:find(obsidian_vault .. "/", 1, true) == 1
end

return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}

      local current = opts.servers.marksman or {}
      local previous_on_attach = current.on_attach
      local previous_publish = current.handlers and current.handlers["textDocument/publishDiagnostics"]

      current.filetypes = { "markdown" }
      current.on_attach = function(client, bufnr)
        if in_obsidian_vault(vim.api.nvim_buf_get_name(bufnr)) then
          client.server_capabilities.documentLinkProvider = false
        end

        if type(previous_on_attach) == "function" then
          previous_on_attach(client, bufnr)
        end
      end

      current.handlers = current.handlers or {}
      current.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
        if result and result.diagnostics then
          result.diagnostics = vim.tbl_filter(function(d)
            local msg = (d.message or ""):lower()
            return not msg:find("spelling", 1, true)
          end, result.diagnostics)
        end

        if type(previous_publish) == "function" then
          return previous_publish(err, result, ctx, config)
        end
        return vim.lsp.handlers["textDocument/publishDiagnostics"](err, result, ctx, config)
      end

      current.root_dir = function(path_or_bufnr)
        local util = require("lspconfig.util")
        local fname = resolve_path(path_or_bufnr)
        if not fname then
          return nil
        end

        if in_obsidian_vault(fname) and obsidian_vault then
          return obsidian_vault
        end

        return util.root_pattern(".marksman.toml", ".git")(fname) or util.path.dirname(fname)
      end

      opts.servers.marksman = current
    end,
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      opts.formatters = opts.formatters or {}
      opts.formatters["markdownlint-cli2"] = vim.tbl_deep_extend(
        "force",
        opts.formatters["markdownlint-cli2"] or {},
        {
          args = {
            "--config",
            vim.fn.stdpath("config") .. "/markdownlint-cli2.jsonc",
            "--fix",
            "$FILENAME",
          },
        }
      )
    end,
  },
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters = {
        ["markdownlint-cli2"] = {
          args = { "--config", vim.fn.stdpath("config") .. "/markdownlint-cli2.jsonc", "-" },
        },
      },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("render-markdown").setup({
        bullet = {
          right_pad = 1,
        },
      })
    end,
  },
}
