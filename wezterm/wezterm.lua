local wezterm = require("wezterm")
local config = wezterm.config_builder()

local style = require("config.style")
local colors = require("config.colors")
local keys = require("config.keybindings")

local tabs = require("config.tabs")
local utils = require("config.utils")

local M = {
  colors = colors,
  keys = keys,
  style = style,
}

for _, map in pairs(M) do
    for k, v in pairs(map) do
        config[k] = v
    end
end

tabs.setup_tab_tittle(wezterm, utils)
tabs.setup_tab(wezterm)

return config
