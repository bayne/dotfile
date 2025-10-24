#!/usr/bin/env -S uv run --script
import subprocess

DEVICES = [
    "DeckLink Quad HDMI Recorder (1)",
    "DeckLink Quad HDMI Recorder (2)",
    "DeckLink Quad HDMI Recorder (3)",
    "DeckLink Quad HDMI Recorder (4)",
]

FFPLAY_EXEC = f"/home/bpayne/Code/mine/ffmpeg/ffplay"

def get_options() -> dict[str, tuple[str, str]]:
    options = {
        "0:\tWork MBP": ("DeckLink Quad HDMI Recorder (1)", 'work_mbp')
    }
    for i, device in enumerate(DEVICES, len(options)):
        options[f"{i}:\t{device}"] = (device, device)
    return options

options = get_options()
options_string = '\n'.join(options.keys())
r = subprocess.run(
    [
        'rofi', '-dmenu',
    ],
    input=options_string,
    capture_output=True,
    text=True,
)
selection = r.stdout.strip()
if selection not in options:
    exit(1)
selected_display, window_name = options[selection]
r = subprocess.run(
    [
        FFPLAY_EXEC,
        '-f', 'decklink', selected_display,
        '-window_title', window_name,
        "-queue_size", "178956971",
        "-decklink_copyts", "true",
        "-probesize", "32",
        "-fflags", "nobuffer",
        "-flags", "low_delay",
        "-threads", "1",
        "-sync", "video",
        "-framedrop",
        "-an",
        "-analyzeduration", "0",
        "-avioflags", "direct",
        "-fs",
        "-sws_flags", "neighbor",
    ],
)