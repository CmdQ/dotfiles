
# Keep only the first occurrence of each duplicated value.
# path is the array version of PATH.
typeset -U PATH path

path_appends=(
    '.toolbox/bin'
    'Library/Application Support/Coursier/bin'
    'Library/Application Support/JetBrains/Toolbox/scripts'
)
for append in "${path_appends[@]}";
do
	[[ -d $HOME/$append ]] && path+="$HOME/$append"
done

alias bws='brazil ws'
alias bwscreate='bws create --root'

alias bb=brazil-build
alias bba='brazil-build apollo-pkg'
alias bre='brazil-runtime-exec'
# https://w.amazon.com/bin/view/EnvImprovementNinjas/BrazilRecursiveCmdParallel/
if command -v brazil-recursive-cmd-parallel &>/dev/null; then
    alias brc='brazil-recursive-cmd-parallel'
else
    alias brc='brazil-recursive-cmd'
fi
alias brb='brc brazil-build'
# Do a command in all packages.
# - Works with aliases, i.e. you can keep typing bb.
# - Prints the name of the package before giving output (no guessing).
# - Doesn't change your PWD.
bra() {
    local frame
    frame=$(printf '#%.0s' $(seq 1 30))
    for dir in $(bws show --format json | jq -r '.packages[].source_location')
    do
        (
            echo
            echo "$frame" "$(basename "$dir")" "$frame"
            cd "$dir" || return
            eval "$@"
        )
    done
    echo
}
alias bbb='bra brazil-build'
alias bbra='brb apollo-pkg'
# Append D or DS to
# /apollo/bin/env -e WalletHEXService brazil-build server
# to have it enable debug mode.
alias -g D='-Ddebug.enable=y'
alias -g DS='-Ddebug.enable=y -Ddebug.suspend=y'

default_host_name=clouddesk

is_amazon_laptop() {
    [[ $(hostname) = *.ant.amazon.com ]]
}

is_clouddesk() {
    [[ $(hostname) = dev-dsk-$USER-* ]]
}

# This saves you from running
# mwinit -o
# on your clouddesk after connecting.
# - It doesn't always work though.
# - Of course you need a valid cookie on your local to begin with.
transfer_mw_cookie() {
    is_amazon_laptop && scp {,"${1:-$default_host_name}":}~/.midway/cookie >/dev/null
}

# Transfer Midway cookie, connect to clouddesk and start tmux right away.
tunnel() {
    if is_clouddesk; then
        echo "It seems you are already on your cloud desktop."
        return
    fi

    local host
    host="${1:-$default_host_name}"

    if is_amazon_laptop; then
        pgrep -x ssh-agent >/dev/null || [[ -S $SSH_AUTH_SOCK ]] || eval "$(ssh-agent -s)"
    fi
    ssh-add -qt 1d & transfer_mw_cookie "$host"
    if command -v et >/dev/null; then
        # https://github.com/MisterTea/EternalTerminal
        et -f -t 1044:1044,5005:5005 "$@" "$host" -c tmux
    else
        ssh -At -L 1044:localhost:1044 -L 5005:localhost:5005 "$@" "$host" tmux
    fi
}

# Run kinit if it is needed only.
# - This function hides the original command.
kinit() {
    # Only override the no argument call.
    if (( $# > 0 )); then
        command kinit "$@"
    elif ! klist -s; then
        command kinit -f
    fi
}

# Run mwinit if it is needed only.
# - This function hides the original command.
# - Adds -o or -s depending on where it is run.
mwinit() {
    # Only override the no argument call.
    if (( $# > 0 )); then
        command mwinit "$@"
    elif ! command mwinit -l |grep -F "$HOME/.midway/cookie" >/dev/null; then
        if is_amazon_laptop; then
            command mwinit    -s --aea "$@"
        else
            command mwinit -o -s --aea "$@"
        fi
    fi
}

# Single command for both authorizations.
mkinit() {
    kinit
    mwinit
}

export BRAZIL_WORKSPACE_DEFAULT_LAYOUT=short
export AUTO_TITLE_SCREENS=NO
export AWS_EC2_METADATA_DISABLED=true
export AWS_REGION=us-west-2
