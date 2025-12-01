local colores = require("config.color")

local M = {
    colors = {
        background = colores.background_terminal,
        tab_bar = {
            background = colores.background_tabs,
            active_tab = {
                bg_color = colores.background_active_tabs,
                fg_color = colores.foreground_active_tabs,
            },
            new_tab = {
                bg_color = colores.background_new_tab,
                fg_color = colores.foreground_new_tab,
            },
        },
    }

}
return M
