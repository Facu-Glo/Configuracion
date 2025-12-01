local function hex_a_rgb(hex_color)
    local hex = hex_color:gsub("^#", "")

    local r = tonumber(string.sub(hex, 1, 2), 16)
    local g = tonumber(string.sub(hex, 3, 4), 16)
    local b = tonumber(string.sub(hex, 5, 6), 16)

    return r, g, b
end

local M = {
    background_terminal = '#1c1c1f',
    background_active_tabs = '#7aa2f7',
    foreground_active_tabs = '#000000',
    foreground_new_tab = '#ffffff',
    status_leader = '#c099ff',
    status_key_table = '#e5c890',
    status_app = '#81c8be',
}

local r, g, b = hex_a_rgb(M.background_terminal)
local opacity_tabs = 0.95
local opacity_new_tab = 0.92

M.background_tabs = string.format("rgba(%d,%d,%d,%.2f)", r, g, b, opacity_tabs)
M.background_new_tab = string.format("rgba(%d,%d,%d,%.2f)", r, g, b, opacity_new_tab)

return M
