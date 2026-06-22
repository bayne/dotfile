# Reset
Color_Off="\[\033[0m\]"
Color_Off_Raw="\033[0m"

# Regular Colors
Black="\[\033[0;30m\]"
Black_Raw="\033[0;30m"
Red="\[\033[0;31m\]"
Red_Raw="\033[0;31m"
Green="\[\033[0;32m\]"
Green_Raw="\033[0;32m"
Yellow="\[\033[0;33m\]"
Yellow_Raw="\033[0;33m"
Blue="\[\033[0;34m\]"
Blue_Raw="\033[0;34m"
Purple="\[\033[0;35m\]"
Purple_Raw="\033[0;35m"
Cyan="\[\033[0;36m\]"
Cyan_Raw="\033[0;36m"
White="\[\033[0;37m\]"
White_Raw="\033[0;37m"

# Bold
BBlack="\[\033[1;30m\]"
BBlack_Raw="\033[1;30m"
BRed="\[\033[1;31m\]"
BRed_Raw="\033[1;31m"
BGreen="\[\033[1;32m\]"
BGreen_Raw="\033[1;32m"
BYellow="\[\033[1;33m\]"
BYellow_Raw="\033[1;33m"
BBlue="\[\033[1;34m\]"
BBlue_Raw="\033[1;34m"
BPurple="\[\033[1;35m\]"
BPurple_Raw="\033[1;35m"
BCyan="\[\033[1;36m\]"
BCyan_Raw="\033[1;36m"
BWhite="\[\033[1;37m\]"
BWhite_Raw="\033[1;37m"

# Underline
UBlack="\[\033[4;30m\]"
UBlack_Raw="\033[4;30m"
URed="\[\033[4;31m\]"
URed_Raw="\033[4;31m"
UGreen="\[\033[4;32m\]"
UGreen_Raw="\033[4;32m"
UYellow="\[\033[4;33m\]"
UYellow_Raw="\033[4;33m"
UBlue="\[\033[4;34m\]"
UBlue_Raw="\033[4;34m"
UPurple="\[\033[4;35m\]"
UPurple_Raw="\033[4;35m"
UCyan="\[\033[4;36m\]"
UCyan_Raw="\033[4;36m"
UWhite="\[\033[4;37m\]"
UWhite_Raw="\033[4;37m"

# Background
On_Black="\[\033[40m\]"
On_Black_Raw="\033[40m"
On_Red="\[\033[41m\]"
On_Red_Raw="\033[41m"
On_Green="\[\033[42m\]"
On_Green_Raw="\033[42m"
On_Yellow="\[\033[43m\]"
On_Yellow_Raw="\033[43m"
On_Blue="\[\033[44m\]"
On_Blue_Raw="\033[44m"
On_Purple="\[\033[45m\]"
On_Purple_Raw="\033[45m"
On_Cyan="\[\033[46m\]"
On_Cyan_Raw="\033[46m"
On_White="\[\033[47m\]"
On_White_Raw="\033[47m"

# High Intensity
IBlack="\[\033[0;90m\]"
IBlack_Raw="\033[0;90m"
IRed="\[\033[0;91m\]"
IRed_Raw="\033[0;91m"
IGreen="\[\033[0;92m\]"
IGreen_Raw="\033[0;92m"
IYellow="\[\033[0;93m\]"
IYellow_Raw="\033[0;93m"
IBlue="\[\033[0;94m\]"
IBlue_Raw="\033[0;94m"
IPurple="\[\033[0;95m\]"
IPurple_Raw="\033[0;95m"
ICyan="\[\033[0;96m\]"
ICyan_Raw="\033[0;96m"
IWhite="\[\033[0;97m\]"
IWhite_Raw="\033[0;97m"

# Bold High Intensity
BIBlack="\[\033[1;90m\]"
BIBlack_Raw="\033[1;90m"
BIRed="\[\033[1;91m\]"
BIRed_Raw="\033[1;91m"
BIGreen="\[\033[1;92m\]"
BIGreen_Raw="\033[1;92m"
BIYellow="\[\033[1;93m\]"
BIYellow_Raw="\033[1;93m"
BIBlue="\[\033[1;94m\]"
BIBlue_Raw="\033[1;94m"
BIPurple="\[\033[1;95m\]"
BIPurple_Raw="\033[1;95m"
BICyan="\[\033[1;96m\]"
BICyan_Raw="\033[1;96m"
BIWhite="\[\033[1;97m\]"
BIWhite_Raw="\033[1;97m"

# High Intensity backgrounds
On_IBlack="\[\033[0;100m\]"
On_IBlack_Raw="\033[0;100m"
On_IRed="\[\033[0;101m\]"
On_IRed_Raw="\033[0;101m"
On_IGreen="\[\033[0;102m\]"
On_IGreen_Raw="\033[0;102m"
On_IYellow="\[\033[0;103m\]"
On_IYellow_Raw="\033[0;103m"
On_IBlue="\[\033[0;104m\]"
On_IBlue_Raw="\033[0;104m"
On_IPurple="\[\033[0;105m\]"
On_IPurple_Raw="\033[0;105m"
On_ICyan="\[\033[0;106m\]"
On_ICyan_Raw="\033[0;106m"
On_IWhite="\[\033[0;107m\]"
On_IWhite_Raw="\033[0;107m"

# Full-width status-bar background (the first prompt line). Change the
# 256-color index (236 = dark gray) to recolor the whole bar.
Bar_BG="\[\033[48;5;236m\]"
Bar_BG_Raw="\033[48;5;236m"

CL_PROMPT_MARKER="⌘cl⌘ "

# Various variables for PS1 prompt
Time12h="\T"
Time12a="\@"
PathShort="\w"
PathFull="\W"
NewLine="\n"
Jobs="\j"

# Get host color from hostcolor command
if command -v hostcolor &>/dev/null; then
    HostColor=$(hostname | hostcolor)
    HostColor=${HostColor^}
    HostColorVar=${!HostColor}
    HostColorVar_Raw="${HostColor}_Raw"
    HostColorVar_Raw=${!HostColorVar_Raw}
else
    HostColorVar="$Green"
    HostColorVar_Raw="$Green_Raw"
fi

# Record command start time. _cmd_start is integer SECONDS (legacy duration
# display); _cmd_start_us is microseconds from EPOCHREALTIME for the
# millisecond-precision duration tmxb needs. The `:-` keeps the *first* real
# command's start time across a multi-command line. This single DEBUG trap also
# fires for the PROMPT_COMMAND hooks (`set_prompt`, direnv's `_direnv_hook`) —
# skip them so a bare Enter never arms the timer (and so never produces a
# spurious tmxb emit). tmxb is wired in here instead of sourcing tmxb.bash,
# which would fight this trap and PROMPT_COMMAND for the single slot each owns.
command_timer_start() {
    case $BASH_COMMAND in set_prompt*|_direnv_hook*) return ;; esac
    _cmd_start=${_cmd_start:-$SECONDS}
    _cmd_start_us=${_cmd_start_us:-${EPOCHREALTIME/./}}
    _cmd_name=${_cmd_name:-$BASH_COMMAND}
}

# Stop the timer and forward long-running commands to tmxb. $1 is the finished
# command's exit code, captured at the top of set_prompt before anything
# clobbers $?. tmxb applies its own duration threshold and no-ops outside tmux,
# so we always hand it the event; we still honor the local ~/.exclude-command
# list the old notifier used.
command_timer_stop() {
    local rc=${1:-0}

    # First prompt of the shell: the timer was armed by .bashrc's own startup
    # commands, and `command` is a stale line from the previous session. Swallow
    # it once so we never emit a bogus startup event.
    if [[ -z $_cmd_prompt_ready ]]; then
        _cmd_prompt_ready=1
        unset _cmd_start _cmd_name _cmd_start_us
        return
    fi

    # Nothing ran since the last prompt (a bare Enter): _cmd_start_us is unset,
    # so there is no command to report.
    if [[ -z $_cmd_start_us ]]; then
        unset _cmd_start _cmd_name _cmd_start_us
        return
    fi

    local duration=$(( SECONDS - ${_cmd_start:-$SECONDS} ))
    local ms=$(( ( ${EPOCHREALTIME/./} - _cmd_start_us ) / 1000 ))
    local _command=$(echo "${command}" | cut -f3- -d' ')
    local excluded=false


    if [[ -f ~/.exclude-command ]]; then
        while IFS= read -r pattern; do
            if [[ $_command =~ $pattern ]]; then
                excluded=true
            fi
        done < ~/.exclude-command
    fi

#    if (( duration >= 60 )) && [[ "$excluded" == false ]]; then
#        (agent-smith send "\"${_command}\" finished in ${duration}s (exit: $?)" &>/dev/null &)
#    fi

    # Surface long-running commands in rofi / warp-back-to-pane via tmxb.
    # Detached so a slow or missing listener never blocks the prompt.
    if [[ "$excluded" == false ]] && command -v tmxb &>/dev/null; then
        ( tmxb emit --exit-code "$rc" --duration-ms "$ms" -- $_command >/dev/null 2>&1 & ) 2>/dev/null
    fi

    unset _cmd_start _cmd_name _cmd_start_us
}

cd_rw_52x_record() {
    command cd-rw-52x --record "$PWD" 2>/dev/null
}

# Register existing file paths from the last command as GTK recent files,
# so they appear in the Chrome/GTK file chooser "Recent" section.
__recent_register() {
    (python3 -c "
import subprocess, sys, os
from gi.repository import GLib

xbel_path = os.path.expanduser('~/.local/share/recently-used.xbel')
bm = GLib.BookmarkFile()
try:
    bm.load_from_file(xbel_path)
except Exception:
    pass

now = GLib.DateTime.new_now_local()
for path in sys.argv[1:]:
    uri = GLib.filename_to_uri(path)
    try:
        out = subprocess.check_output(
            ['gio', 'info', '--attributes=standard::content-type', path],
            stderr=subprocess.DEVNULL, text=True)
        mime = 'application/octet-stream'
        for line in out.splitlines():
            if 'content-type' in line:
                mime = line.split(':', 1)[1].strip()
                break
    except Exception:
        mime = 'application/octet-stream'
    bm.set_mime_type(uri, mime)
    bm.add_application(uri, 'bash', 'bash %u')
    bm.set_visited_date_time(uri, now)

bm.to_file(xbel_path)
" "$@" 2>/dev/null &)

}

__recent_from_command() {
    local -a words
    read -ra words <<< "$1"

    local -a found_files=()
    local word resolved

    for word in "${words[@]}"; do
        [[ "$word" == -* ]] && continue
        [[ "$word" == *'|'* || "$word" == *'>'* || "$word" == *'<'* || "$word" == *'$'* ]] && continue
        if [[ "$word" == ~/* ]]; then
            word="${HOME}${word:1}"
        fi
        if [[ "$word" == /* ]]; then
            resolved="$word"
        else
            resolved="${PWD}/${word}"
        fi
        if [[ -f "$resolved" ]]; then
            found_files+=("$resolved")
        fi
    done

    if (( ${#found_files[@]} )); then
        __recent_register "${found_files[@]}"
    fi
}

# ── bh: log commands to systemd journal for `bh history recall` ──
__bh_log_command() {
    local cmd
    cmd=$(fc -ln -1 | sed 's/^[[:space:]]*//;s/[[:space:]]*$//') 
    command -v logger &>/dev/null && logger -p user.notice -t bash_command "$USER: $(date '+%Y-%m-%d %H:%M:%S') $cmd"
}

set_prompt() {
    # Capture the finished command's exit code first — history/git below clobber
    # $?. direnv's hook runs ahead of us in PROMPT_COMMAND but preserves $?, so
    # this is still the user command's status.
    local rc=$?
    local git_status

    # Logging (moved from PROMPT_COMMAND in .bashrc)
    history -a
    command=$(history 1 | sed "s/^[ ]*[0-9]*[ ]*//")
    __bh_log_command
    __recent_from_command "$command"

    # Full-width bar: re-assert ${bg} after each foreground color because
    # many color vars start with "0;" (a full SGR reset that also clears
    # the background). Mid-bar resets use "${off}${bg}" to drop foreground
    # attributes while keeping the bar background.
    local bg="$Bar_BG" off="\[\033[0m\]"
    local bar="${bg}${CL_PROMPT_MARKER}${IBlack}${bg}${Time12h}${BICyan}${bg} \u${BIWhite}${bg}@${HostColorVar}${bg}\h"

    # Git integration
    if git branch &>/dev/null; then
        # inside the `if git branch &>/dev/null` block:
        local branch_count=$(git branch | grep -v '^\*' | wc -l)
        local worktree_count=$(( $(git worktree list | wc -l) - 1))

        if (( worktree_count > 0 )); then
            bar+=" ${IBlack}${bg}b:${branch_count} w:${On_Yellow}${BBlack}${worktree_count}${off}${bg}"
        else
            bar+="${IBlack}${bg} b:${branch_count} w:${worktree_count}"
        fi
        

        git_status=$(git status 2>/dev/null)
        if type -t __git_ps1 &>/dev/null; then
            if echo "$git_status" | grep -q "nothing to commit"; then
                # Clean repository
                bar+="${Green}${bg}\$(__git_ps1 ' (%s)')"
            else
                # Dirty repository
                bar+="${Red}${bg}\$(__git_ps1 ' (%s)')"
            fi
        fi


        bar+=" ${BYellow}${bg}${PathShort}"
    else
        # Not in a git repo
        bar+=" ${Yellow}${bg}${PathShort}"
    fi

    # Fill the rest of the line with the bar background via erase-to-EOL
    # (ESC[K): with the background set, the terminal paints from the cursor
    # to the real right edge itself, so there's no width math and it
    # re-fits on resize (readline re-emits the prompt on SIGWINCH). ESC[K
    # is zero-width (the cursor doesn't move), so it's wrapped in \[..\].
    # tmux/alacritty/xterm back-colour-erase even where terminfo omits it.
    # Line 2 ("\$ ") stays uncoloured and short so editing never wraps.
    PS1="${bar}${bg}\[\033[K\]${off}\n\$ "

    (cd_rw_52x_record &)
    command_timer_stop "$rc"
    [ -n "$TMUX" ] && tmux select-pane -T "" \; set-window-option automatic-rename on 2>/dev/null
}

# Keep $COLUMNS current after a terminal resize so the full-width bar
# re-fits on the next prompt instead of overflowing and wrapping.
shopt -s checkwinsize

trap 'command_timer_start' DEBUG
PROMPT_COMMAND="set_prompt"
