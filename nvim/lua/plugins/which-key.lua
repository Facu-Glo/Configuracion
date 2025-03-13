return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "modern",
  },
  keys = {
    {
      "'d",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Eliminar marcas",
    },
    {
      "<leader>r",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Relative number",
    },
  },
}
