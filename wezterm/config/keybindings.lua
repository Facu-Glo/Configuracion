local wezterm = require("wezterm")
local act = wezterm.action
local M = {}

M.leader = { key = 'b', mods = 'CTRL', timeout_milliseconds = 3000 }

M.keys = {
    -- Pane management
    { key = '|', mods = 'LEADER',   action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    { key = 'v', mods = 'LEADER',   action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    { key = '-', mods = 'LEADER',   action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
    { key = 's', mods = 'LEADER',   action = act.SplitVertical { domain = 'CurrentPaneDomain' } },

    { key = 'x', mods = 'LEADER',   action = act.CloseCurrentPane { confirm = true } },

    -- Activate resize mode
    { key = 'r', mods = 'LEADER',   action = act.ActivateKeyTable { name = 'resize_pane', one_shot = false } },

    -- Rotate Panes
    { key = 'p', mods = 'LEADER',   action = act.ActivateKeyTable { name = 'rotate_pane', one_shot = false } },

    -- Scroll
    { key = 'n', mods = 'LEADER',   action = act.ActivateKeyTable { name = 'navegation', one_shot = false } },

    -- Scroll to prompt
    -- { key = 'k', mods = 'CTRL', action = act.ScrollToPrompt(-1) },
    -- { key = 'j', mods = 'CTRL', action = act.ScrollToPrompt(1) },

    -- Move between panes with CTRL + ALT + HJKL
    { key = 'h', mods = 'CTRL|ALT', action = act.ActivatePaneDirection 'Left' },
    { key = 'l', mods = 'CTRL|ALT', action = act.ActivatePaneDirection 'Right' },
    { key = 'k', mods = 'CTRL|ALT', action = act.ActivatePaneDirection 'Up' },
    { key = 'j', mods = 'CTRL|ALT', action = act.ActivatePaneDirection 'Down' },

    -- Index pane
    { key = '0', mods = 'CTRL',     action = act.PaneSelect { alphabet = '1234567890' } },
    { key = 't', mods = 'LEADER',   action = act.ShowTabNavigator },

    -- Move pane to new tab
    {
        key = '!',
        mods = 'LEADER | SHIFT',
        action = wezterm.action_callback(function(win, pane)
            local tab, window = pane:move_to_new_tab()
        end),
    },
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
    rotate_pane = {
        { key = 'h',      action = act.RotatePanes 'CounterClockwise' },
        { key = 'l',      action = act.RotatePanes 'Clockwise' },
        { key = 'Escape', action = 'PopKeyTable' },
    },
    navegation = {
        { key = 'k',      action = act.ScrollByLine(-1) },
        { key = 'j',      action = act.ScrollByLine(1) },
        { key = 'u',      action = act.ScrollByPage(-1) },
        { key = 'd',      action = act.ScrollByPage(1) },
        { key = 'G',      action = act.ScrollToBottom },
        { key = 'g',      action = act.ActivateKeyTable { name = 'goto_mode', one_shot = true } },
        { key = 'z',      action = act.ScrollToPrompt(-1) },
        { key = 'x',      action = act.ScrollToPrompt(1) },
        { key = 'Escape', action = 'PopKeyTable' },
    },
    goto_mode = {
        { key = 'g',      action = act.ScrollToTop },
        { key = 'Escape', action = 'PopKeyTable' },
    },
}

-- Activate tab by number
for i = 1, 8 do
    table.insert(M.keys, {
        key = tostring(i),
        mods = 'ALT',
        action = act.ActivateTab(i - 1),
    })
end

-- Move tab to position
for i = 1, 8 do
    -- CTRL+ALT + number to move to that position
    table.insert(M.keys, {
        key = tostring(i),
        mods = 'CTRL|ALT',
        action = wezterm.action.MoveTab(i - 1),
    })
end

return M
