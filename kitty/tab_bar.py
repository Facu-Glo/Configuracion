# pyright: reportMissingImports=false
from kitty.boss import get_boss
from kitty.fast_data_types import Screen
from kitty.tab_bar import (
    DrawData,
    ExtraData,
    TabBarData,
    TabAccessor,
    as_rgb,
    draw_tab_with_separator,
)

def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_title_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    
    active_id = get_boss().active_tab.id
    active_tab = TabAccessor(active_id)
    
    # Guardar colores originales
    old_fg = screen.cursor.fg
    old_bg = screen.cursor.bg
    
    # Dibujar icono de aplicación en la primera pestaña (lado izquierdo)
    if index == 1:
        title = active_tab.active_oldest_exe
        screen.cursor.italic = False
        screen.cursor.bold = False
        screen.cursor.fg = as_rgb(0x81C8BE)
        screen.cursor.bg = as_rgb(0x232634)
        cell = f" {title}"
        screen.draw(cell)
    
    # Dibujar separador según si la pestaña está activa o no
    if tab.is_active:
        screen.cursor.fg = as_rgb(int(draw_data.active_bg))
        screen.cursor.bg = as_rgb(int(draw_data.inactive_bg))
        screen.draw(" ▐█")
    elif extra_data.prev_tab is None or extra_data.prev_tab.tab_id != active_id:
        screen.cursor.bg = as_rgb(int(draw_data.inactive_bg))
        screen.cursor.fg = as_rgb(int(0x626880))
        screen.draw(" │ ")
    
    # Restaurar colores
    screen.cursor.fg = old_fg
    screen.cursor.bg = old_bg
    
    draw_tab_with_separator(
        draw_data,
        screen,
        tab,
        before,
        max_title_length,
        index,
        is_last,
        extra_data,
    )
    
    # Dibujar separador derecho solo para la última pestaña o pestañas activas
    if tab.is_active:
        screen.cursor.fg = as_rgb(int(draw_data.active_bg))
        if is_last:
            screen.cursor.bg = as_rgb(int(draw_data.default_bg))
        else:
            screen.cursor.bg = as_rgb(int(draw_data.inactive_bg))
        screen.draw("█▌ ")
    elif is_last:
        screen.cursor.fg = as_rgb(int(draw_data.inactive_bg))
        screen.cursor.bg = as_rgb(int(draw_data.default_bg))
        screen.draw("█▌ ")
    
    return screen.cursor.x
