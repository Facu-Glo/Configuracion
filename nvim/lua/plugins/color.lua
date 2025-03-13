return {
  "norcalli/nvim-colorizer.lua",
  enabled = true,
  lazy = false,
  config = function()
    require("colorizer").setup()
  end,
}
