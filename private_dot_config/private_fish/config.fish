if status is-interactive
    # Commands to run in interactive sessions can go here
    source ~/.config/fish/aliases.fish
    source ~/.config/fish/git_aliases.fish
end

set -l brew_paths /opt/homebrew /home/linuxbrew/.linuxbrew
for path in $brew_paths
    if test -x $path/bin/brew
        eval ($path/bin/brew shellenv)
        break
    end
end

fish_add_path --global --append $HOME/.local/bin $HOME/.dotnet/tools $HOME/.cargo/bin $HOME/miniconda3/bin

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /home/clash/miniconda3/bin/conda
    eval /home/clash/miniconda3/bin/conda "shell.fish" "hook" $argv | source
else
    if test -f "/home/clash/miniconda3/etc/fish/conf.d/conda.fish"
        . "/home/clash/miniconda3/etc/fish/conf.d/conda.fish"
    else
        set -x PATH "/home/clash/miniconda3/bin" $PATH
    end
end
# <<< conda initialize <<<

