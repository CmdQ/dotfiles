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
alias bra='brc --allPackages'
alias bbb='bra brazil-build'
alias bbra='brb apollo-pkg'
alias -g D='-Ddebug.enable=y'
alias -g DS='-Ddebug.enable=y -Ddebug.suspend=y'

if command -v et >/dev/null
then
    alias tunnel='et -f -t 1044:1044,5005:5005 clouddesk'
else
    alias tunnel='ssh -A -L 1044:localhost:1044 -L 5005:localhost:5005 clouddesk'
fi

export BRAZIL_WORKSPACE_DEFAULT_LAYOUT=short
export AUTO_TITLE_SCREENS=NO
export AWS_EC2_METADATA_DISABLED=true
