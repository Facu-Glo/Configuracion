-- Salir de NVIM
-- vim.keymap.set("n", "<C-q>", ":q<CR>", { noremap = true, silent = true })

--Buffer
vim.keymap.set("n", "<Tab>", ":bnext<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", { noremap = true, silent = true })

-- Press jk fast to exit insert mode
vim.keymap.set("i", "jj", "<ESC>")

-- Select all
vim.keymap.set("n", "<leader>a", function()
  vim.cmd("keepjumps normal! ggVG")
end, { desc = "Seleccionar todo el archivo" })

-- Activar/Desactivar numeros relativos
vim.keymap.set("n", "<leader>ra", function()
  vim.opt.relativenumber = true
end, { desc = "Activar números relativos" })

vim.keymap.set("n", "<leader>rd", function()
  vim.opt.relativenumber = false
end, { desc = "Desactivar números relativos" })

-- Eliminar las marcas
vim.keymap.set("n", "'dd", ":delmarks!<CR>", { desc = "Eliminar todas las marcas" })

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
vim.keymap.set("t", "<C-Up>", "<cmd>resize +1<cr>")
vim.keymap.set("t", "<C-Down>", "<cmd>resize -1<cr>")

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

-- Explorador archivo
vim.keymap.set(
  "n",
  "<leader>e",
  ":lua Snacks.picker.explorer()<CR>",
  { desc = "Abrir el explorador de archivos", noremap = true, silent = true }
)

-- Snacks picker
vim.keymap.set(
  "n",
  "<leader><leader>",
  ":lua Snacks.picker.files()<CR>",
  { desc = "Buscar archivos", noremap = true, silent = true }
)
vim.keymap.set(
  "n",
  "<leader>ff",
  ":lua Snacks.picker.files()<CR>",
  { desc = "Buscar archivos (cwd)", noremap = true, silent = true }
)
vim.keymap.set(
  "n",
  "<leader>fg",
  ":lua Snacks.picker.grep()<CR>",
  { desc = "Buscar texto en archivos", noremap = true, silent = true }
)
vim.keymap.set(
  "n",
  "<leader>fb",
  ":lua Snacks.picker.buffers()<CR>",
  { desc = "Buffers", noremap = true, silent = true }
)
vim.keymap.set(
  "n",
  "<leader>fk",
  ":lua Snacks.picker.keymaps()<CR>",
  { desc = "keymaps", noremap = true, silent = true }
)
vim.keymap.set(
  "n",
  "<leader>z",
  ":lua Snacks.picker.zoxide()<CR>",
  { desc = "Buscar directorios (zoxide)", noremap = true, silent = true }
)
vim.keymap.set(
  "n",
  "<leader>fh",
  ":lua Snacks.picker.files({ cwd = vim.fn.expand('~') })<CR>",
  { desc = "Buscar archivos (home)", noremap = true, silent = true }
)
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
