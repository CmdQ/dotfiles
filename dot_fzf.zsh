fzf_home="$(brew --prefix)/opt/fzf"
[[ -d $fzf_home ]] || echo Not setting up fzf. && return

if [[ -n $INTERACTIVE ]]; then
    source "$fzf_home/shell/completion.zsh" 2> /dev/null
    source "$fzf_home/shell/key-bindings.zsh"
fi
