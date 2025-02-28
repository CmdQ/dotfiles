if status is-interactive
    # Commands to run in interactive sessions can go here
    source ~/.config/fish/aliases.fish
    source ~/.config/fish/git_aliases.fish

    fish_add_path --global --prepend /opt/homebrew/bin
    fish_add_path --global $HOME/.local/bin $HOME/.dotnet/tools $HOME/.cargo/bin
end
