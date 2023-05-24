# No duplicates!
typeset -U path

path_appends=(
    '.toolbox/bin'
    'Library/Application Support/Coursier/bin'
    'Library/Application Support/JetBrains/Toolbox/scripts'
)
for append in $path_appends;
do
	[[ -d $HOME/$append ]] && path+="$HOME/$append"
done

alias bws='brazil ws'
alias bwscreate='bws create -n'

alias bb=brazil-build
alias bba='brazil-build apollo-pkg'
alias bre='brazil-runtime-exec'
if command -v brazil-recursive-cmd-parallel &>/dev/null
then
    alias brc='brazil-recursive-cmd-parallel'
else
    alias brc='brazil-recursive-cmd'
fi
alias brb='brc brazil-build'
bra() {
    local cmd=$1
    shift
    local frame=$(printf '#%.0s' $(seq 1 30))
    for dir in $(bws show --format json | jq -r '.packages[].source_location')
    do
        (
            echo
            echo $frame $(basename $dir) $frame
            cd "$dir" || return
            eval "$cmd" "$@"
        )
    done
    echo
}
alias bbb='bra brazil-build'
alias bbra='brb apollo-pkg'
alias -g D='-Ddebug.enable=y'
alias -g DS='-Ddebug.enable=y -Ddebug.suspend=y'

tunnel() {
    local host_name=clouddesk
    [[ -S $SSH_AUTH_SOCK ]] || eval "$(ssh-agent)"
    ssh-add -t 1d
    if command -v et >/dev/null
    then
        local tunnel_cmd="et -f -t 1044:1044,5005:5005 $host_name"
    else
        local tunnel_cmd="ssh -A -L 1044:localhost:1044 -L 5005:localhost:5005 $host_name"
    fi
    scp {,$host_name:}~/.midway/cookie >/dev/null & eval "$tunnel_cmd"
}

if [[ `hostname` = *.ant.amazon.com ]]
then
    alias mkinit='mwinit -s --aea'
else
    alias mkinit='kinit -f && mwinit -o'
fi

export BRAZIL_WORKSPACE_DEFAULT_LAYOUT=short
export AUTO_TITLE_SCREENS=NO
export AWS_EC2_METADATA_DISABLED=true

