
# No duplicates!
typeset -U path

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
if command -v brazil-recursive-cmd-parallel &>/dev/null; then
    alias brc='brazil-recursive-cmd-parallel'
else
    alias brc='brazil-recursive-cmd'
fi
alias brb='brc brazil-build'
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
alias cr='cr --destination-branch mainline'
alias -g D='-Ddebug.enable=y'
alias -g DS='-Ddebug.enable=y -Ddebug.suspend=y'

default_host_name=clouddesk

is_amazon_laptop() {
    [[ $(hostname) = *.ant.amazon.com ]]
}

is_clouddesk() {
    [[ $(hostname) = dev-dsk-$USER-* ]]
}

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
    ssh-add -qt 1d
    if command -v et >/dev/null; then
        et -f -t 1044:1044,5005:5005 "$@" "$host" -c tmux
    else
        ssh -At -L 1044:localhost:1044 -L 5005:localhost:5005 "$@" "$host" tmux
    fi
}

# This function hides the original command.
kinit() {
    # Only override the no argument call.
    if (( $# > 0 )); then
        command kinit "$@"
    elif ! klist -s; then
        command kinit -f
    fi
}

# This function hides the original command.
mwinit() {
    # Only override the no argument call.
    if (( $# > 0 )); then
        command mwinit "$@"
    elif ! command mwinit -l |grep -F "$HOME/.midway/cookie" >/dev/null; then
        if is_amazon_laptop; then
            command mwinit -s --aea "$@"
        else
            command mwinit -o "$@"
        fi
    fi
}

mkinit() {
    kinit
    mwinit
}

export BRAZIL_WORKSPACE_DEFAULT_LAYOUT=short
export AUTO_TITLE_SCREENS=NO
export AWS_EC2_METADATA_DISABLED=true
export AWS_REGION=us-west-2

