alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

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

type -q lazygit; and alias lg=lazygit
type -q fdfind; and alias fd=fdfind
type -q aichat; and alias ai=aichat
type -q aichat; and alias how2='aichat -e'
type -q aider; and alias aider='aider --model=azure/gpt-4.1-mini'
alias wincp='rsync -av --chmod=D755,F644'

if set -q WSL_DISTRO_NAME
	if type -q wslview
		alias v=wslview
		alias wp=wslpath
		alias wv=wslvar
		alias xnv='"/mnt/c/Program Files/XnViewMP/xnviewmp.exe"'
		alias xnvb='"/mnt/c/Program Files/XnViewMP/xnviewmp.exe" -browse'
	else
		echo "! sudo apt install wslu"
	end
	alias expl=explorer.exe
	alias pbcopy=clip.exe
	alias wsl-kill='wsl.exe --shutdown'
end
