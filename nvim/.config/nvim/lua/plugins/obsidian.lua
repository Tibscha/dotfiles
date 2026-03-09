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

  return vim.fs.normalize(vim.uv.cwd())
end

return {
  {
    url = "https://github.com/obsidian-nvim/obsidian.nvim",
    name = "obsidian.nvim",
    branch = "main",
    lazy = true,
    event = {
      "BufReadPre *.md",
      "BufNewFile *.md",
    },
    cmd = {
      "Obsidian",
      "ObsidianOpen",
      "ObsidianQuickSwitch",
      "ObsidianSearch",
      "ObsidianNew",
      "ObsidianToday",
      "ObsidianYesterday",
      "ObsidianTomorrow",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      {
        "<leader>or",
        function()
          vim.cmd("ObsidianRef")
        end,
        desc = "Obsidian reference popup",
      },
      {
        "<leader>ok",
        function()
          vim.cmd("ObsidianRef keybindings")
        end,
        desc = "Obsidian keybindings popup",
      },
      {
        "<leader>on",
        function()
          vim.cmd("Obsidian new_from_template")
        end,
        desc = "New note from template",
      },
    },
    init = function()
      local vault = resolve_vault_path()
      local references = {
        keybindings = "nvim-keybindings.md",
      }

      local function open_note_popup(relative_path, title)
        if type(relative_path) ~= "string" or relative_path == "" then
          vim.notify("ObsidianRef: missing note path", vim.log.levels.WARN)
          return
        end

        local abs_path = vim.fs.joinpath(vault, relative_path)
        if vim.fn.filereadable(abs_path) == 0 then
          vim.notify("ObsidianRef: note not found -> " .. abs_path, vim.log.levels.WARN)
          return
        end

        local ok, snacks = pcall(require, "snacks")
        if not ok then
          vim.notify("ObsidianRef: snacks.nvim is not available", vim.log.levels.ERROR)
          return
        end

        snacks.win({
          file = abs_path,
          width = 0.75,
          height = 0.8,
          border = "rounded",
          enter = true,
          fixbuf = false,
          title = " " .. (title or vim.fs.basename(relative_path)) .. " ",
          wo = {
            wrap = true,
            spell = false,
            signcolumn = "no",
            statuscolumn = " ",
            conceallevel = 2,
          },
        })
      end

      vim.api.nvim_create_user_command("ObsidianPeek", function(opts)
        open_note_popup(opts.args)
      end, {
        nargs = 1,
        complete = "file",
        desc = "Open Obsidian note in floating popup",
        force = true,
      })

      vim.api.nvim_create_user_command("ObsidianRef", function(opts)
        local target = opts.args
        if target == "" then
          local choices = vim.tbl_keys(references)
          table.sort(choices)
          vim.ui.select(choices, { prompt = "Open Obsidian reference" }, function(choice)
            if choice then
              open_note_popup(references[choice], choice)
            end
          end)
          return
        end

        local path = references[target] or target
        open_note_popup(path, references[target] and target or nil)
      end, {
        nargs = "?",
        complete = function(arg_lead)
          local items = {}
          for name, _ in pairs(references) do
            if name:find("^" .. vim.pesc(arg_lead)) then
              table.insert(items, name)
            end
          end
          table.sort(items)
          return items
        end,
        desc = "Open predefined Obsidian reference popup",
        force = true,
      })
    end,
    opts = function()
      local vault = resolve_vault_path()
      return {
        legacy_commands = false,
        ui = {
          enable = false,
        },
        workspaces = {
          {
            name = "vault",
            path = vault,
          },
        },
        templates = {
          folder = "templates",
        },
        new_notes_location = "notes_subdir",
        notes_subdir = ".",
      }
    end,
  },
}
