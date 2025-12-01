local wezterm = require("wezterm")
local config = wezterm.config_builder()

local configuration = {
  style = require("config.style"),
  keys = require("config.keybindings"),
  config_term = require("config.config"),
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
