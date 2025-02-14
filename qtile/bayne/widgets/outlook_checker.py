import sys
from datetime import datetime

from libqtile import widget

import subprocess, requests, pytz

def _get_password(entry):
    result = subprocess.run(["pass", entry], capture_output=True, text=True, check=True)
    return result.stdout.strip()

class OutlookChecker(widget.base.ThreadPoolText):
    SHOW_AS_RANK = {
        "busy": 0,
        "tentative": 1,
    }

    defaults = [
        ("update_interval", 600, "Update time in seconds."),
        ("timezone", pytz.timezone('America/Los_Angeles'), "Timezone"),
        ("foreground", "33ff33", "foreground color"),
        ("foreground_active", "ff8888", "foreground color when meeting is active"),
    ]

    def __init__(self, **config):
        widget.base.ThreadPoolText.__init__(self, "", **config)
        self.add_defaults(OutlookChecker.defaults)
        self.markup = False
        self.foreground_inactive = self.foreground
        self.url = _get_password("outlook-event-url")
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
