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
On_IPurple="\[\033[10;95m\]"
On_IPurple_Raw="\033[10;95m"
On_ICyan="\[\033[0;106m\]"
On_ICyan_Raw="\033[0;106m"
On_IWhite="\[\033[0;107m\]"
On_IWhite_Raw="\033[0;107m"

# Various variables for PS1 prompt
Time12h="\T"
Time12a="\@"
PathShort="\w"
PathFull="\W"
NewLine="\n"
Jobs="\j"

# Get host color from hostcolor command
HostColor=$(hostname | hostcolor)
HostColor=${HostColor^}
HostColorVar=${!HostColor}
HostColorVar_Raw="${HostColor}_Raw"
HostColorVar_Raw=${!HostColorVar_Raw}

set_prompt() {
    local git_status

    # Logging (moved from PROMPT_COMMAND in .bashrc)
    history -a
    command=$(history 1 | sed "s/^[ ]*[0-9]*[ ]*//")
    logger -p user.notice -t bash_command "$USER: $command"

    # Base prompt: time, user@host
    PS1="${IBlack}${Time12h}${BICyan} \u${BIWhite}@${HostColorVar}\h${Color_Off}"

    # Git integration
    if git branch &>/dev/null; then
        git_status=$(git status 2>/dev/null)
        if echo "$git_status" | grep -q "nothing to commit"; then
            # Clean repository
            PS1+="${Green}\$(__git_ps1 ' (%s)')${Color_Off} "
        else
            # Dirty repository
            PS1+="${Red}\$(__git_ps1 ' (%s)')${Color_Off} "
        fi
        PS1+="${BYellow}${PathShort}${Color_Off}\n\$ "
    else
        # Not in a git repo
        PS1+=" ${Yellow}${PathShort}${Color_Off}\n\$ "
    fi
}

PROMPT_COMMAND=set_prompt
