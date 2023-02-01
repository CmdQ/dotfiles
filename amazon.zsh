appends=(
    ".toolbox/bin"
    "Library/Application Support/Coursier"
    "Library/Application Support/JetBrains/Toolbox/scripts"
)
for append in $appends;
do
	[[ -d $HOME/$append ]] && [[ :$PATH: == *:"$HOME/$append":* ]] || PATH="$PATH:$HOME/$append"
done

alias bws='brazil ws'
alias bwscreate='bws create -n'

bb() {brazil-build}
alias bba='brazil-build apollo-pkg'
alias bre='brazil-runtime-exec'
if command -v brazil-recursive-cmd-parallel &>/dev/null; then
    alias brc='brazil-recursive-cmd-parallel'
else
    alias brc='brazil-recursive-cmd'
fi
alias brb='brc brazil-build'
alias bra='brc --allPackages'
alias bbb='bra brazil-build'
alias bbra='brb apollo-pkg'

export BRAZIL_WORKSPACE_DEFAULT_LAYOUT=short
export AUTO_TITLE_SCREENS="NO"
export AWS_EC2_METADATA_DISABLED=true
