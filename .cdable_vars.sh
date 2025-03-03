shopt -s cdable_vars
export qqdot_dotfile_cdv=~/Code/mine/dotfile
export qqmi_mine_cdv=~/Code/mine

if [ -f ~/.cdable_vars.local.sh ]; then
    .  ~/.cdable_vars.local.sh
fi

# Custom directory bookmarks
#CD_BOOKMARKS=("dotfile_cdv")
CD_BOOKMARKS=$(env | fgrep '_cdv=' | cut -f1 -d=)

_cd_custom_complete() {

    _cd

    COMPREPLY+=( $(compgen -W "${CD_BOOKMARKS}" -- "${COMP_WORDS[COMP_CWORD]}") )
}

complete -o nospace -F _cd_custom_complete cd
