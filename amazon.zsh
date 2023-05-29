
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
alias -g D='-Ddebug.enable=y'
alias -g DS='-Ddebug.enable=y -Ddebug.suspend=y'

tunnel() {
    local host_name=clouddesk
    [[ -S $SSH_AUTH_SOCK ]] || eval "$(ssh-agent)"
    ssh-add -t 1d &>/dev/null & scp {,$host_name:}~/.midway/cookie >/dev/null
    if command -v et >/dev/null; then
        et -f -t 1044:1044,5005:5005 "$@" "$host_name"
    else
        ssh -A -L 1044:localhost:1044 -L 5005:localhost:5005 "$@" "$host_name"
    fi
}

is_amazon_laptop() {
    [[ $(hostname) = *.ant.amazon.com ]]
}

kinit() {
    is_amazon_laptop || klist -s || command kinit -f
}

mwinit() {
    if ! command mwinit -l |grep -F "$HOME/.midway/cookie" >/dev/null; then
        if is_amazon_laptop; then
            command mwinit -s --aea "$@"
        else
            command mwinit -o "$@"
        fi
    elif (( $# > 0 )); then
        command mwinit "$@"
    fi
}

mkinit() {
    kinit && mwinit "$@"
}

export BRAZIL_WORKSPACE_DEFAULT_LAYOUT=short
export AUTO_TITLE_SCREENS=NO
export AWS_EC2_METADATA_DISABLED=true
