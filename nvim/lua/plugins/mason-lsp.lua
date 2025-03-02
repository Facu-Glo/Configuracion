return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "rust_analyzer",
          "pyright",
          "asm_lsp",
          "bashls",
          "clangd",
          "gopls",
          "jdtls",
          "hyprls",
          "biome",
          "cssls",
        },
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      -- Configuración de nvim-lspconfig
      local lspconfig = require("lspconfig")

      -- Habilitar capacidades de autocompletado
      local capabilities = require("blink.cmp").get_lsp_capabilities()
      -- Función común para cuando un servidor LSP se adjunta
      local on_attach = function(_, bufnr)
        local bufopts = { noremap = true, silent = true, buffer = bufnr }

        -- Configuración de atajos de teclado comunes
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
        -- vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
      end

      -- Configuración para el servidor de Lua
      lspconfig.lua_ls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" }, -- Definir 'vim' como global
            },
          },
        },
      })

      -- Configuración para el servidor de Rust
      lspconfig.rust_analyzer.setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })

      -- Configuración para el servidor de Python (Pyright)
      lspconfig.pyright.setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })

      -- Configuración para el servidor de ASM
      lspconfig.asm_lsp.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        filetypes = { "nasm", "asm", "s", "S" },
      })

      -- Configuración para el servidor de Bash
      lspconfig.bashls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })

      -- Configuración para el servidor de C/C++ (Clangd)
      lspconfig.clangd.setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })

      -- Configuración para el servidor de Go
      lspconfig.gopls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })

      -- Configuración para el servidor de Java (JDTLS)
      lspconfig.jdtls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })

      lspconfig.hyprls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        filetypes = { "hyprlang", "hypr", "conf" },
      })

      -- Configuración para Lemminx (XML)
      lspconfig.lemminx.setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })

      -- Configuración para Biome (JSON)
      lspconfig.biome.setup({
        cmd = { "biome", "lsp-proxy" },
        filetypes = { "json", "jsonc" },
        root_dir = require("lspconfig.util").root_pattern(".git", "package.json", "biome.json", "biome.jsonc"),
      })

      -- Configuración para CSS
      lspconfig.cssls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })
    end,
  },
}
