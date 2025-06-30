if status is-interactive
    # Commands to run in interactive sessions can go here
    source ~/.config/fish/aliases.fish
    source ~/.config/fish/git_aliases.fish
end

set -l brew_paths /opt/homebrew /home/linuxbrew/.linuxbrew
for path in $brew_paths
    if test -x $path/bin/brew
        eval ($path/bin/brew shellenv)
        # Add Homebrew completions to Fish's completion path
        set -gx fish_complete_path $fish_complete_path $path/share/fish/vendor_completions.d
        break
    end
end

fish_add_path --global --append $HOME/.local/bin $HOME/.dotnet/tools $HOME/.cargo/bin
