appends=(
    ".toolbox/bin"
    "Library/Application Support/Coursier"
    "Library/Application Support/JetBrains/Toolbox/scripts"
)
for append in $appends;
do
	[[ -d $HOME/$append ]] && [[ :$PATH: == *:"$HOME/$append":* ]] || PATH="$PATH:$HOME/$append"
done

alias bb=brazil-build
alias bba='brazil-build apollo-pkg'
alias bre='brazil-runtime-exec'
alias brc='brazil-recursive-cmd'
alias bws='brazil ws'
alias bwscreate='bws create -n'
alias bbr='brc brazil-build'
alias bball='brc --allPackages'
alias bbb='brc --allPackages brazil-build'
alias bbra='bbr apollo-pkg'
