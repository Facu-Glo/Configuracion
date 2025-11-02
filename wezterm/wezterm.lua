local wezterm = require("wezterm")

local config = wezterm.config_builder()

local colors = require("colors")
local keys = require("keybindings")
local tabs = require("tabs")
local utils = require("utils")

config.font = wezterm.font("JetBrains Mono Nerd Font")
config.font_rules = {
    { intensity = "Bold", font = wezterm.font("JetBrains Mono Nerd Font", { weight = "ExtraBold" }) },
}
config.font_size = 12.5
config.color_scheme = "Tokyo Night (Gogh)"
config.use_fancy_tab_bar = false
config.window_decorations = "RESIZE"
config.initial_rows = 38
config.initial_cols = 160
config.tab_max_width = 40
config.window_background_opacity = 0.92
config.show_new_tab_button_in_tab_bar = true
config.window_padding = {
    left = '0cell',
    right = '0cell',
    top = '0.6cell',
    bottom = '0.0cell',
}

config.colors = colors
config.leader = keys.leader
config.keys = keys.keys
config.key_tables = keys.key_tables

tabs.setup_tab_formatting(wezterm, utils)

wezterm.on('update-right-status', function(window)
    local mode = window:active_key_table()
    window:set_right_status(mode and ('MODE: ' .. mode) or '')
end)

return config
