make_aliases() {
	alias ...='cd ../..'
	alias ....='cd ../../..'
	alias .....='cd ../../../..'

	local ls=ls
	if command -v lsd &>/dev/null; then
		ls=lsd
		alias ls="$ls"
		alias l="$ls -l --group-dirs=first"
		alias ll="$ls -la --group-dirs=first"
		alias ld="$ls -lt --date=relative"
		alias lt="$ls --tree"
	else
		alias ls="$ls --color=auto -F"
		alias l="$ls -l"
		alias ll="$ls -la"
		alias ld="$ls -lt"
	fi
	alias la="$ls -a"

	alias wincp='rsync -av --chmod=D755,F644'

	if command -v nvim &>/dev/null; then
		alias vim=nvim
		EDITOR=nvim
	elif command -v vim &>/dev/null; then
		EDITOR=vim
	elif command -v joe &>/dev/null; then
		EDITOR=joe
	elif command -v nano &>/dev/null; then
		EDITOR=nano
	fi
	export EDITOR

	if command -v rg >/dev/null && command -v sk >/dev/null; then
		local skrg='rg --color=always --line-number "{}"'
		alias skf="sk --ansi -i -c '$skrg'"
	fi

	command -v lazygit >/dev/null && alias lg=lazygit
	command -v fdfind >/dev/null && alias fd=fdfind
	command -v aichat >/dev/null && alias ai=aichat
	command -v aichat >/dev/null && alias how2='aichat -e'
}
make_aliases
