#!/usr/bin/env -S uv run --script
import subprocess

DEVICES = [
    "DeckLink Quad HDMI Recorder (1)",
    "DeckLink Quad HDMI Recorder (2)",
    "DeckLink Quad HDMI Recorder (3)",
    "DeckLink Quad HDMI Recorder (4)",
]

FFPLAY_EXEC = f"/home/bpayne/Code/mine/ffmpeg/ffplay"
TERMINAL_EXEC = f"/usr/bin/alacritty"

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
        TERMINAL_EXEC,
        '--hold',
        '-e',
        FFPLAY_EXEC,
#        "-raw_format", "uyvy422",
#        "-raw_format", "yuv422p10",
        "-raw_format", "argb",
        "-format_code", "Hp60",
        #"-format_code", "wqh6",
        "-fflags", "nobuffer",
        "-flags", "low_delay",
        "-probesize", "32",
        "-analyzeduration", "0",
        "-avioflags", "direct",
        "-max_delay", "0",
        "-queue_size", "36864000",
        '-f', 'decklink',
        "-i", selected_display,
        '-window_title', window_name,
        "-decklink_copyts", "true",
        "-threads", "1",
        "-sync", "ext",
        "-framedrop",
        "-an",
        "-fs",
        "-sws_flags", "neighbor",
        "-vf", "setpts=0",
    ],
)
