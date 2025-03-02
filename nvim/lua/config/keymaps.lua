-- Select all
vim.keymap.set("n", "<C-a>", function()
  vim.cmd("keepjumps normal! ggVG")
end, { desc = "Seleccionar todo el archivo" })

vim.keymap.set("n", "'dm", ":delmarks!<CR>", { desc = "Eliminar todas las marcas" })

-- Ir primer caracter de una linea
vim.keymap.set({ "n", "v" }, "<leader>0", "^", { noremap = true, silent = true, desc = "Ir al inicio de la linea" })

-- Ir al final de una linea
vim.keymap.set({ "n", "v" }, "<leader>9", "$", { noremap = true, silent = true, desc = "Ir al final de la linea" })

-- Guardar con Ctrl+s en modo normal y visual
vim.keymap.set({ "n", "v" }, "<C-s>", ":w<CR>", { noremap = true, silent = true })

-- Guardar con Ctrl+s en modo inserción
vim.keymap.set("i", "<C-s>", "<Esc>:w<CR>", { noremap = true, silent = true })

-- Terminal
vim.keymap.set({ "n", "t" }, "<leader>t", function()
  require("snacks.terminal").toggle(nil, { cwd = vim.fn.getcwd() })
end, { desc = "Toggle terminal" })

--Redimensionar terminal
vim.keymap.set("t", "<C-Up>", "<cmd>resize +2<cr>")
vim.keymap.set("t", "<C-Down>", "<cmd>resize -2<cr>")

-- Oil
vim.keymap.set("n", "<leader>o", "<CMD>Oil --float<CR>", { desc = "Open Oil in current directory" })

-- Movimiento de lineas
vim.api.nvim_set_keymap("n", "<A-k>", ":m .-2<CR>==", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<A-j>", ":m .+1<CR>==", { noremap = true, silent = true })

vim.api.nvim_set_keymap("v", "<A-k>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<A-j>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })

-- Activar wrap
vim.keymap.set("n", "<A-z>", function()
  local wrap_enabled = vim.wo.wrap
  vim.wo.wrap = not wrap_enabled
  vim.wo.breakindent = not wrap_enabled
  if wrap_enabled then
    print("Wrap desactivado")
  else
    print("Wrap activado")
  end
end, { desc = "Toggle line wrapping with Alt+Z" })

--vim.api.nvim_set_keymap("n", "<leader>nh", ":nohlsearch<CR>", { noremap = true, silent = true })

-- Abrir ventana en panel lateral
--vim.api.nvim_set_keymap("n", "<leader>|", ":vsplit<CR>", { noremap = true, silent = true })

-- Abrir ventana en panel inferior
--vim.api.nvim_set_keymap("n", "<leader>-", ":split<CR>", { noremap = true, silent = true })

-- Cerrar la ventana actual (sin cerrar Neovim)
--vim.api.nvim_set_keymap("n", "<leader>wc", ":close<CR>", { noremap = true, silent = true })

-- Mapeo para mover el foco de ventana a la derecha (Ctrl + L)
vim.api.nvim_set_keymap("n", "<C-l>", ":wincmd l<CR>", { noremap = true, silent = true })

-- Mapeo para mover el foco de ventana a la izquierda (Ctrl + H)
vim.api.nvim_set_keymap("n", "<C-h>", ":wincmd h<CR>", { noremap = true, silent = true })

-- Navegar al split de arriba con Ctrl + h
vim.api.nvim_set_keymap("n", "<C-k>", "<C-w>k", { noremap = true, silent = true })

-- Navegar al split de abajo con Ctrl + j
vim.api.nvim_set_keymap("n", "<C-j>", "<C-w>j", { noremap = true, silent = true })

--vim.keymap.set("n", "<leader>f", function()
--	require("conform").format({ async = true })
--end, { noremap = true, silent = true, desc = "Format file" })
--
--vim.api.nvim_create_autocmd("BufWritePre", {
--	pattern = "*",
--	callback = function(args)
--		require("conform").format({ bufnr = args.buf })
--	end,
--})

-- ####################### Telescope ##################################### --

--local builtin = require("telescope.builtin")
--
--vim.keymap.set("n", "<leader><leader>", builtin.find_files, { desc = "Telescope find files" })
--vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
--vim.keymap.set("n", "<leader>fg", builtin.live_grep, { noremap = true, silent = true, desc = "Live Grep" })
--vim.keymap.set("n", "<leader>fb", builtin.buffers, { noremap = true, silent = true, desc = "Find Buffers" })
--vim.keymap.set("n", "<leader>fh", builtin.help_tags, { noremap = true, silent = true, desc = "Find Help" })
--
-- ####################################################################### --
