fish_add_path --global $HOME/.dotnet/tools $HOME/.cargo/bin
if status is-interactive
    set -l brew_paths /opt/homebrew /home/linuxbrew/.linuxbrew
    for path in $brew_paths
        if test -x $path/bin/brew
            eval ($path/bin/brew shellenv)
            # Add Homebrew completions to Fish's completion path
            set --global --export fish_complete_path $path/share/fish/vendor_completions.d $fish_complete_path
            break
        end
    end

    # Commands to run in interactive sessions can go here
    source ~/.config/fish/aliases.fish
    source ~/.config/fish/git_aliases.fish
end
fish_add_path --global --prepend --move $HOME/.local/bin

test -r $HOME/.job.fish && source $HOME/.job.fish

if set -q WSL_DISTRO_NAME
    if functions -q fish_command_not_found && ! functions -q __fish_command_not_found_original
        functions -c fish_command_not_found __fish_command_not_found_original
    end

    function fish_command_not_found --description 'WSL fallback: try with .exe, then original handler'
        set -l cmd $argv[1]
        set -l cmd_exe "$cmd.exe"

        if type -q -- $cmd_exe
            $cmd_exe $argv[2..-1]
            return
        end

        if functions -q __fish_command_not_found_original
            __fish_command_not_found_original $argv
            return
        end

        printf "%s: command not found\n" $cmd >&2
        return 127
    end
end

# BEGIN Agency MANAGED BLOCK
fish_add_path "/home/clash/.config/agency/CurrentVersion"
# END Agency MANAGED BLOCK
