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

	alias ppup="python3 -m pip install --upgrade pip && python3 -m pip install wheel"
	alias mipy="mypy --ignore-missing-imports"
	alias pywest="pytest --disable-warnings"
	alias po=poetry

	if command -v rg >/dev/null && command -v sk >/dev/null; then
		local skrg='rg --color=always --line-number "{}"'
		alias skf="sk --ansi -i -c '$skrg'"
	fi

	command -v lazygit >/dev/null && alias lg=lazygit

	[[ -d /Applications/portacle/Portacle.app ]] && alias portacle='open -a /Applications/portacle/Portacle.app'
}
make_aliases
