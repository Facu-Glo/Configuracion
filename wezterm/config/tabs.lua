local M = {}

function M.setup_tab_formatting(wezterm, utils)
    wezterm.on("format-tab-title", function(tab, _, _, _, _, _)
        local pane = tab.active_pane
        local cwd_uri = pane.current_working_dir
        local directoryName = cwd_uri and utils.getDirectoryName(cwd_uri.file_path) or "Unknown"

        local process_name = pane.foreground_process_name:match("([^/\\]+)%.exe$")
            or pane.foreground_process_name:match("([^/\\]+)$")

        if process_name == "zsh" then
            process_name = directoryName
        end

        local index = tab.tab_index + 1
        local title = string.format(" %s %s ", index, process_name)

        return { { Text = title } }
    end)
end

return M
