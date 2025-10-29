alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

begin
    set -l dir ls
    if type -q lsd
        set -l dir lsd
        alias ls=$dir
        alias l="$dir -l --group-dirs=first"
        alias ll="$dir -la --group-dirs=first"
        alias ld="$dir -ltr --date=relative"
        alias lt="$dir --tree"
    else
        alias ls="$dir --color=auto -F"
        alias l="$dir -l"
        alias ll="$dir -la"
        alias ld="$dir -ltr"
    end
    alias la="ls -a"
end

type -q lazygit && alias lg=lazygit
type -q fdfind && alias fd=fdfind
type -q aichat && alias ai=aichat
type -q aichat && alias how2='aichat -e'
type -q aider && alias aider='aider --model=azure/gpt-4.1-mini'
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

function pyformat
    if ! type -q uv
        echo "Need uv for this."
    else
        set cmd uv
        set isort
        uv run ruff -V &>/dev/null
        if test $status -ne 0
            set -a cmd tool
            set isort --select I
        end
        set -a cmd run ruff
        $cmd format && $cmd check --fix $isort $argv
    end
end
