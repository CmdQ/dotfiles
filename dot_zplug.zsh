zplug_home="$HOME/.zplug/init.zsh"

# https://github.com/zplug/zplug
# curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
if [[ -r $zplug_home ]] && source "$zplug_home"; then
	zplug 'plugins/aws', from:oh-my-zsh
	zplug 'plugins/fd', from:oh-my-zsh
	zplug 'plugins/sudo', from:oh-my-zsh
	zplug 'plugins/poetry', from:oh-my-zsh

	zplug 'zsh-users/zsh-autosuggestions'
	zplug 'zsh-users/zsh-syntax-highlighting'

	export ENHANCD_COMMAND=cd
	export ENHANCD_DOT_ARG='.'
	zplug 'b4b4r07/enhancd', use:init.sh

	if [[ `uname` == Darwin ]]; then
		zplug 'plugins/maxos', from:oh-my-zsh
	fi

	zplug 'plugins/ripgrep', from:oh-my-zsh

	# Install plugins if there are plugins that have not been installed
	if ! zplug check --verbose; then
		printf 'Install? [y/N]: '
		if read -q; then
			echo; zplug install
		fi
	fi

	# Then, source plugins and add commands to $PATH
	zplug load
fi

# Undo the prompt changes by the aws plugin.
export PROMPT="
%{$fg[white]%}(%D %*) <%?> [%~] $program %{$fg[default]%}
%{$fg[cyan]%}%m %#%{$fg[default]%} "
unset RPROMPT
