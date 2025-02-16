from typing import List

from libqtile import layout, widget, bar, hook, log_utils, qtile
from libqtile.config import Group, Screen, Mouse, Key
from libqtile.layout.base import Layout
from libqtile.lazy import lazy
import asyncio

from bayne import get_default_keys, get_default_switch_group_keys, get_default_mouse
from bayne import systemd_logging
from bayne.hooks import popover
from bayne import get_widget_defaults, get_default_floating, get_default_layouts

popover.init(restack=[
    'jetbrains-idea'
])
systemd_logging.init()

logger = log_utils.logger

mod = "mod4"
# https://github.com/qtile/qtile/blob/master/libqtile/backend/x11/xkeysyms.py
keys = get_default_keys(mod)

groups = [Group(name=i, screen_affinity=0) for i in "123456789"]
keys.extend(get_default_switch_group_keys(mod, 9))
keys.extend([
    Key([], 'XF86MonBrightnessUp', lazy.spawn('sudo light -A 10'), desc='Increase brightness'),
    Key([], 'XF86MonBrightnessDown', lazy.spawn('sudo light -U 10'), desc='Decrease brightness'),
])

layouts: List[Layout] = get_default_layouts()

widget_defaults: dict = get_widget_defaults()
extension_defaults = widget_defaults.copy()

screens: List[Screen] = [
    Screen(
        background="#555",
        top=bar.Bar(
            widgets=[
                widget.GroupBox(),
                widget.WindowName(),
                widget.Clock(format="%a %b %d %I:%M:%S %p"),
                widget.Spacer(),
                widget.Backlight(backlight_name='amdgpu_bl0'),
                widget.Battery(),
                widget.Systray(),
            ],
            size=24,
            background="#222",
        ),
    )
]

# Drag floating layouts.
mouse: List[Mouse] = get_default_mouse(mod)
dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = False
bring_front_click: bool = False
floats_kept_above: bool = True
cursor_warp: bool = False
floating_layout: layout.Floating = layout.Floating(
   float_rules=[
       *layout.Floating.default_float_rules,
       *get_default_floating(),
   ]
)
auto_fullscreen: bool = True
focus_on_window_activation: bool = "smart"
reconfigure_screens: bool = True
auto_minimize = True
wmname = "LG3D"
