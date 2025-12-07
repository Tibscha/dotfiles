vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.opt.number = true
vim.opt.relativenumber = true
vim.keymap.set('i', '<C-s>', '<Esc>:w<CR>', { silent = true })
-- In Visual Mode: Text in System-Clipboard kopieren
vim.keymap.set('v', '<leader>y', '"+y', { desc = "Copy to system clipboard" })

-- In Normal Mode: Aktuelle Zeile in System-Clipboard kopieren
vim.keymap.set('n', '<leader>Y', '"+yy', { desc = "Copy line to system clipboard" })

-- In Normal Mode: Alles in System-Clipboard kopieren
vim.keymap.set('n', '<leader>gy', 'gg"+yG', { desc = "Copy entire buffer to system clipboard" })
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.opt.colorcolumn = "80"
  end,
})

