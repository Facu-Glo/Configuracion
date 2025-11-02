local wezterm = require("wezterm")
local act = wezterm.action
local M = {}

M.leader = { key = 'b', mods = 'CTRL', timeout_milliseconds = 2000 }

M.keys = {
    -- Splits
    { key = '|', mods = 'LEADER',   action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    { key = 'v', mods = 'LEADER',   action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    { key = '-', mods = 'LEADER',   action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
    { key = 's', mods = 'LEADER',   action = act.SplitVertical { domain = 'CurrentPaneDomain' } },

    { key = 'x', mods = 'LEADER',   action = act.CloseCurrentPane { confirm = true } },

    -- Activate resize mode
    { key = 'r', mods = 'LEADER',   action = act.ActivateKeyTable { name = 'resize_pane', one_shot = false } },

    -- Move between panes with CTRL + ALT + HJKL
    { key = 'h', mods = 'CTRL|ALT', action = act.ActivatePaneDirection 'Left' },
    { key = 'l', mods = 'CTRL|ALT', action = act.ActivatePaneDirection 'Right' },
    { key = 'k', mods = 'CTRL|ALT', action = act.ActivatePaneDirection 'Up' },
    { key = 'j', mods = 'CTRL|ALT', action = act.ActivatePaneDirection 'Down' },

    -- Index pane
    { key = '0', mods = 'CTRL',     action = act.PaneSelect { alphabet = '1234567890' } },
}

M.key_tables = {
    resize_pane = {
        { key = 'h',          action = act.AdjustPaneSize { 'Left', 1 } },
        { key = 'l',          action = act.AdjustPaneSize { 'Right', 1 } },
        { key = 'k',          action = act.AdjustPaneSize { 'Up', 1 } },
        { key = 'j',          action = act.AdjustPaneSize { 'Down', 1 } },
        { key = 'LeftArrow',  action = act.AdjustPaneSize { 'Left', 1 } },
        { key = 'RightArrow', action = act.AdjustPaneSize { 'Right', 1 } },
        { key = 'UpArrow',    action = act.AdjustPaneSize { 'Up', 1 } },
        { key = 'DownArrow',  action = act.AdjustPaneSize { 'Down', 1 } },
        { key = 'Escape',     action = 'PopKeyTable' },
    },
}

for i = 1, 8 do
    table.insert(M.keys, {
        key = tostring(i),
        mods = 'ALT',
        action = act.ActivateTab(i - 1),
    })
end

return M
