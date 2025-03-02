return {
  {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "bash",
          "html",
          "javascript",
          "json",
          "java",
          "lua",
          "markdown",
          "markdown_inline",
          "python",
          "query",
          "regex",
          "tsx",
          "typescript",
          "vim",
          "yaml",
          "nasm",
          "hyprlang",
          "xml",
          "rasi",
        },
        highlight = {
          enable = true,
        },

        auto_install = true,

        modules = {},

        sync_install = false,

        ignore_install = {},

        indent = {
          enable = true,
        },
      })
    end,
  },
}
