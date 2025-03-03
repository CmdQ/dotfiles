if status is-interactive
    # Commands to run in interactive sessions can go here
    source ~/.config/fish/aliases.fish
    source ~/.config/fish/git_aliases.fish
end

fish_add_path --global $HOME/.local/bin $HOME/.dotnet/tools $HOME/.cargo/bin

set -l brew_paths /opt/homebrew /home/linuxbrew/.linuxbrew
for path in $brew_paths
    if test -x $path/bin/brew
        eval ($path/bin/brew shellenv)
        break
    end
end
