begin
	set -l dir ls
	if type -q lsd
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
alias pre-commit="uv run pre-commit"

if set -q WSL_DISTRO_NAME
	# sudo apt install wslu
	if command -v wslview > /dev/null
		alias v=wslview
		alias wp=wslpath
		alias wv=wslvar
		alias xnview='"/mnt/c/Program Files/XnViewMP/xnviewmp.exe"'
		alias xnviewb='"/mnt/c/Program Files/XnViewMP/xnviewmp.exe" -browse'
	end
	alias expl=explorer.exe
	alias pbcopy=clip.exe
	alias wsl-kill='wsl.exe --shutdown'
end
