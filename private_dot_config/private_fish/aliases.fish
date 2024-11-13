begin
	set -l dir ls
	if type -q lsda
		set -l dir lsd
		alias ls $dir
		alias l="$dir -l --group-dirs=first"
		alias ll="$dir -la --group-dirs=first"
		alias ld="$dir -lt --date=relative"
		alias lt="$dir --tree"
	else
		alias ls="$dir --color=auto -F"
		alias l="$dir -l"
		alias ll="$dir -la"
		alias ld="$dir -lt"
	end
	alias la="ls -a"
end

alias lg=lazygit
