-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4

vim.filetype.add({
  extension = {
    asm = "nasm",
    rasi = "rasi",
    fxml = "xml",
  },
  pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
})
