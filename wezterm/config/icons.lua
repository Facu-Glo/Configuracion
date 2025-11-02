local wezterm = require("wezterm")

local M = {}

M.process_icons = {
    docker = wezterm.nerdfonts.linux_docker,
    ["docker-compose"] = wezterm.nerdfonts.linux_docker,
    psql = wezterm.nerdfonts.dev_postgresql,
    kuberlr = wezterm.nerdfonts.linux_docker,
    kubectl = wezterm.nerdfonts.linux_docker,
    stern = wezterm.nerdfonts.linux_docker,
    nvim = wezterm.nerdfonts.custom_vim,
    vim = wezterm.nerdfonts.dev_vim,
    zsh = wezterm.nerdfonts.dev_terminal,
    bash = wezterm.nerdfonts.cod_terminal_bash,
    cargo = wezterm.nerdfonts.dev_rust,
    git = wezterm.nerdfonts.dev_git,
    node = wezterm.nerdfonts.dev_nodejs_small,
    lua = wezterm.nerdfonts.seti_lua,
}

function M.get_process_icon(tab)
    local name =
        tab.active_pane.foreground_process_name:match("([^/\\]+)%.exe$")
        or tab.active_pane.foreground_process_name:match("([^/\\]+)$")

    return M.process_icons[name] or wezterm.nerdfonts.seti_checkbox_unchecked
end

return M
