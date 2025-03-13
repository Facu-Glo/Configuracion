-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
--
--

vim.api.nvim_create_autocmd("FileType", {
  pattern = "html",
  callback = function()
    vim.keymap.set(
      "n",
      "<A-l>a",
      ":LiveServerStart<CR>",
      { noremap = true, silent = true, buffer = true, desc = "Iniciar Live Server" }
    )
    vim.keymap.set(
      "n",
      "<A-l>d",
      ":LiveServerStop<CR>",
      { noremap = true, silent = true, buffer = true, desc = "Desactivar Live Server" }
    )
  end,
})

-- noremap = true: Evita el mapeo recursivo.
-- silent  = true: Evita que Neovim muestre la línea de comandos.
-- buffer  = true: Limita el atajo solo a los archivos HTML.
