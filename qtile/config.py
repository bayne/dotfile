# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
import asyncio
import os
import sys
from datetime import datetime, timedelta

from libqtile import bar, layout, qtile, widget, hook, log_utils
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

import subprocess, requests, logging, pytz
from systemd.journal import JournalHandler

logger = log_utils.logger
logger.setLevel(logging.INFO)  # Adjust level as needed

# Create journal handler
journal_handler = JournalHandler()
journal_handler.setFormatter(logging.Formatter("[%(levelname)s] %(message)s"))

# Add handler to Qtile logger
logger.addHandler(journal_handler)

def get_password(entry):
    result = subprocess.run(["pass", entry], capture_output=True, text=True, check=True)
    return result.stdout.strip()

OUTLOOK_EVENT_URL = get_password("outlook-event-url")

class OutlookChecker(widget.base.ThreadPoolText):
    SHOW_AS_RANK = {
        "busy": 0,
        "tentative": 1,
    }

    defaults = [
        ("update_interval", 600, "Update time in seconds."),
        ("timezone", pytz.timezone('America/Los_Angeles'), "Timezone"),
        ("url", OUTLOOK_EVENT_URL, "URL with events"),
        ("foreground", "33ff33", "foreground color"),
        ("foreground_active", "ff8888", "foreground color when meeting is active"),
    ]

    def __init__(self, **config):
        widget.base.ThreadPoolText.__init__(self, "", **config)
        self.add_defaults(OutlookChecker.defaults)
        self.markup = False
        self.foreground_inactive = self.foreground
        self.force_update()

    def _show_as_rank(self, show_as: str) -> int:
        if show_as not in self.SHOW_AS_RANK:
            return sys.maxsize
        return self.SHOW_AS_RANK[show_as]

    def _get_datetime(self, date_string: str):
        return pytz.utc.localize(datetime.fromisoformat(date_string)).astimezone(self.timezone)

    def poll(self):
        now = datetime.now(self.timezone)

        response = requests.get(self.url)
        events = response.json()['value']
        events = filter(lambda e: e['isReminderOn'] or e['showAs'] == 'busy', events)
        events = sorted(events, key=lambda e: self._show_as_rank(e['showAs']))
        events = filter(lambda e: self._get_datetime(e['start']) > now or now <= self._get_datetime(e['end']), events)
        next_event = min(events, default={}, key=lambda e: e['start'])
        if not next_event:
            return "No next event"

        subject, start, end = next_event['subject'], next_event['start'], next_event['end']
        start = self._get_datetime(start)
        end = self._get_datetime(end)
        day = datetime.strftime(start, "%a")
        start_time = datetime.strftime(start, "%-I:%M %p")
        end_time = datetime.strftime(end, "%-I:%M %p")

        if start <= now <= end:
            self.foreground = self.foreground_active
        else:
            self.foreground = self.foreground_inactive

        return f"[[{subject} {day} @ {start_time}-{end_time}]]"

@hook.subscribe.client_managed
async def restack_intellij(client):
    if "jetbrains-idea" in client.get_wm_class() and client.has_focus:
        await asyncio.sleep(0.5)
        client.bring_to_front()

@hook.subscribe.client_new
async def center_modal(client):
    if "center-modal" in client.get_wm_class() and client.has_focus:
        client.enable_floating()
        client.bring_to_front()
        client.center()

@hook.subscribe.client_new
async def gpauth(client):
    if "gpauth" in client.get_wm_class() and client.has_focus:
        client.enable_floating()
        client.bring_to_front()
        client.center()

@hook.subscribe.startup_once
def startup():
    subprocess.run(["/home/bpayne/.screenlayout/default.sh"])
    subprocess.Popen(["/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1"])
    # home dir backup
    subprocess.Popen(["/usr/bin/vorta"])
    subprocess.run(["/usr/bin/systemctl --user start spice-vdagent"])

# windows key
mod = "mod4"
terminal = guess_terminal()

env = os.environ.copy()
env.update({'PATH': env['PATH'] + ':/home/bpayne/.bin'})

# https://github.com/qtile/qtile/blob/master/libqtile/backend/x11/xkeysyms.py
keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "Tab", lazy.layout.next(), desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # mod1 is alt key
    Key(["mod1", "shift"], "4", lazy.spawn('flameshot gui'), desc="screenshot"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    Key([mod, "control"], "l", lazy.screen.next_group(), desc="next"),
    Key([mod, "control"], "h", lazy.screen.prev_group(), desc="prev"),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([mod], "t", lazy.spawn(terminal), desc="Launch terminal"),
    # Toggle between different layouts as defined below
    # Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
    Key(
        [mod],
        "f",
        lazy.window.toggle_fullscreen(),
        desc="Toggle fullscreen on the focused window",
    ),
    Key([mod], "g", lazy.window.toggle_floating(), desc="Toggle floating on the focused window"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    # Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),

    Key([mod], "r", lazy.spawn(cmd='rofi -show combi -modi "combi" -combi-modi "window,drun,run"',
                               env=env,
                               shell=True), desc="Spawn a command using a prompt widget"),
]

# Add key bindings to switch VTs in Wayland.
# We can't check qtile.core.name in default config as it is loaded before qtile is started
# We therefore defer the check until the key binding is run by using .when(func=...)
for vt in range(1, 8):
    keys.append(
        Key(
            ["control", "mod1"],
            f"f{vt}",
            lazy.core.change_vt(vt).when(func=lambda: qtile.core.name == "wayland"),
            desc=f"Switch to VT{vt}",
        )
    )


groups = [Group(name=i, screen_affinity=0) for i in "12345678"]

for i in groups:
    keys.extend(
        [
            # mod + group number = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(0),
                desc="Switch to group {}".format(i.name),
            ),
            # mod + shift + group number = switch to & move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=False),
                desc="Switch to & move focused window to group {}".format(i.name),
            ),
        ]
    )

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

layouts = [
    # layout.Columns(border_focus_stack=["#d75f5f", "#8f3d3d"], border_width=2, num_columns=3),
    # layout.ScreenSplit(splits=[
    #     {"name": "top", "rect": (0, 0, 1, 0.5), "layout": layout.Columns()},
    #     {"name": "bottom", "rect": (0, 0.5, 1, 0.5), "layout": layout.Columns()},
    # ])
    # layout.Max(),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=3),
    # layout.Bsp(),
    # layout.Matrix(columns=3),
    # layout.MonadTall(),

    layout.MonadThreeCol(auto_maximize=True),

    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Plasma(),
    # layout.Zoomy(),
    # layout.Slice(),
]

widget_defaults = dict(
    font="sans",
    fontsize=12,
    padding=3,
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        background="#111",
        top=bar.Bar(
            widgets=
            [
                # widget.CurrentLayout(),
                widget.GroupBox(),
                # widget.Prompt(),
                widget.WindowName(),
                widget.Clock(format="%a %b %d %I:%M:%S %p"),
                OutlookChecker(),
                # widget.TextBox("default config", name="default"),
                # widget.TextBox("Press &lt;M-r&gt; to spawn", foreground="#d75f5f"),
                # NB Systray is incompatible with Wayland, consider using StatusNotifier instead
                # widget.StatusNotifier(),
                widget.Spacer(),
                widget.Systray(),
            ],
            size=24,
            background="#591a7d"
            # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
            # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
        ),
        # You can uncomment this variable if you see that on X11 floating resize/moving is laggy
        # By default we handle these events delayed to already improve performance, however your system might still be struggling
        # This variable is set to None (no cap) by default, but you can set it to 60 to indicate that you limit it to 60 events per second
        # x11_drag_polling_rate = 60,
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
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(wm_class="floatingvim"),  # gitk
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# xcursor theme (string or None) and size (integer) for Wayland backend
wl_xcursor_theme = None
wl_xcursor_size = 24

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"