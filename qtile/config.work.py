import subprocess
from typing import List

from libqtile import layout, widget, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy

from bayne import get_default_keys, get_default_switch_group_keys
from bayne import systemd_logging
from bayne.hooks import popover
from bayne.widgets.outlook_checker import OutlookChecker
from qtile.bayne import get_widget_defaults, get_default_main_screen, get_default_floating

popover.init(restack=[
    'jetbrains-idea'
])
systemd_logging.init()

@hook.subscribe.startup_once
def startup():
    subprocess.run(["/home/bpayne/.screenlayout/default.sh"])
    subprocess.Popen(["/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1"])
    # home dir backup
    subprocess.Popen(["/usr/bin/vorta"])
    subprocess.run(["/usr/bin/systemctl --user start spice-vdagent"])

mod: str = "mod4"

# https://github.com/qtile/qtile/blob/master/libqtile/backend/x11/xkeysyms.py
keys: List[Key] = get_default_keys(mod)

groups: List[Group] = [Group(name=i, screen_affinity=0) for i in "12345678"]
keys.extend(get_default_switch_group_keys(mod, 8))
keys.extend([
    Key([mod, "control"], "l", lazy.screen.next_group(), desc="next"),
    Key([mod, "control"], "h", lazy.screen.prev_group(), desc="prev"),
])

groups.append(Group(
    name="9",
    screen_affinity=1,
    layouts=[layout.Max()],
))
keys.extend(
    [
        Key(
            [mod, "shift"],
            "9",
            lazy.window.togroup("9", switch_group=False),
            lazy.group["9"].toscreen(1),
            desc="move focused window to group 9",
        ),
    ]
)

layouts = get_default_floating()

widget_defaults = get_widget_defaults()
extension_defaults = widget_defaults.copy()

screens = [
    get_default_main_screen(
        top_widgets=[
            widget.GroupBox(),
            widget.WindowName(),
            widget.Clock(format="%a %b %d %I:%M:%S %p"),
            OutlookChecker(),
            widget.Spacer(),
            widget.Systray(),
        ],
        top_background="#591a7d"
    ),
    Screen(
        width=1920,
        height=1080,
        background="#333",
    )
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = False
bring_front_click = False
floats_kept_above = True
cursor_warp = True
floating_layout = layout.Floating(
    float_rules=[
        *layout.Floating.default_float_rules,
        *get_default_floating(),
        Match(wm_class="center-modal"),
        Match(wm_class="gpauth"),
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True
auto_minimize = True
wmname = "LG3D"