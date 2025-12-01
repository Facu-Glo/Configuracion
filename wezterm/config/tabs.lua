local colores = require("config.color")
local M = {}

function M.setup_tab_tittle(wezterm, utils)
    wezterm.on("format-tab-title", function(tab, _, _, _, _, _)
        local pane = tab.active_pane
        local cwd_uri = pane.current_working_dir
        local directoryName = cwd_uri and utils.getDirectoryName(cwd_uri.file_path) or "Unknown"

        local index = tab.tab_index + 1
        local title = string.format(" %s: %s ", index, directoryName)

        return { { Text = title } }
    end)
end

function M.setup_tab(wezterm)
    wezterm.on("update-status", function(window, pane)
        local basename = function(s)
            return string.gsub(s, "(.*[/\\])(.*)", "%2")
        end

        local cmd = pane:get_foreground_process_name()
        cmd = cmd and basename(cmd) or "no-proc"

        local bg_color = colores.background_terminal
        local fg_color = colores.status_app

        window:set_left_status(wezterm.format({
            { Background = { Color = bg_color } },
            { Foreground = { Color = fg_color } },
            { Attribute = { Intensity = "Bold" } },
            { Text = " " .. wezterm.nerdfonts.oct_flame .. " " .. cmd .. "  " },
        }))
    end)
end

function M.setup_status(wezterm)
    wezterm.on('update-right-status', function(window)
        local status = ""
        local status_color = ""

        if window:leader_is_active() then
            status = "[LEADER]"
            status_color = colores.status_leader
        elseif window:active_key_table() then
            status = "[" .. window:active_key_table() .. "]"
            status_color = colores.status_key_table
        end

        window:set_right_status(wezterm.format({
            { Foreground = { Color = status_color } },
            { Attribute = { Intensity = "Bold" } },
            { Text = status },
        }))
    end)
end

return M
