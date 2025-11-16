local wezterm = require("wezterm")
local config = wezterm.config_builder()

local configuration = {
  colors = require("config.colors"),
  keys = require("config.keybindings"),
  style = require("config.config"),
}

local tabs = require("config.tabs")
local utils = require("config.utils")

for _, map in pairs(configuration) do
    for k, v in pairs(map) do
        config[k] = v
    end
end

tabs.setup_tab_tittle(wezterm, utils)
-- tabs.setup_tab(wezterm)
tabs.setup_status(wezterm)

return config
