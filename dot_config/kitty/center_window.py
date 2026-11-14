# Centers kitty on the screen it opens on. Only the first window is moved, so
# new tabs, splits and additional OS windows are left where they are.
from typing import Any

from kitty.boss import Boss
from kitty.fast_data_types import get_os_window_pos, get_os_window_size, glfw_get_monitor_workarea, set_os_window_pos
from kitty.window import Window


def on_resize(boss: Boss, window: Window, data: dict[str, Any]) -> None:
    if data['old_geometry'].xnum or sum(1 for _ in boss.all_windows) != 1:
        return
    os_window_id = window.os_window_id
    x, y = get_os_window_pos(os_window_id)
    size = get_os_window_size(os_window_id)
    width, height = size['width'], size['height']
    mid_x, mid_y = x + width // 2, y + height // 2
    for left, top, area_width, area_height in glfw_get_monitor_workarea():
        if left <= mid_x < left + area_width and top <= mid_y < top + area_height:
            set_os_window_pos(
                os_window_id,
                left + max(0, (area_width - width) // 2),
                top + max(0, (area_height - height) // 2),
            )
            return
