local wezterm = require("wezterm")

local M = {
    font = wezterm.font("JetBrains Mono Nerd Font"),
    font_rules = {
        { intensity = "Bold", font = wezterm.font("JetBrains Mono Nerd Font", { weight = "ExtraBold" }) },
    },
    font_size = 11.5,
    color_scheme = "Tokyo Night (Gogh)",
    use_fancy_tab_bar = false,
    window_decorations = "RESIZE",
    initial_rows = 38,
    initial_cols = 160,
    tab_max_width = 40,
    window_background_opacity = 0.92,
    show_new_tab_button_in_tab_bar = true,
    window_padding = {
        left = '0cell',
        right = '0cell',
        top = '0.6cell',
        bottom = '0.0cell',
    },
    inactive_pane_hsb = {
        saturation = 0.9,
        brightness = 0.7,
    },
    mouse_bindings = {
        {
            event = { Up = { streak = 1, button = 'Left' } },
            mods = 'NONE',
            action = wezterm.action.CompleteSelectionOrOpenLinkAtMouseCursor 'Clipboard',
        },
    },
}

return M
