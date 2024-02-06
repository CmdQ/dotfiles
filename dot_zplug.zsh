zplug_home="$HOME/.zplug/init.zsh"

#prompt_before="$PROMPT"

# https://github.com/zplug/zplug
# curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh

zplug_home="$HOME/.zplug/init.zsh"
if [[ -f $zplug_home ]] && source "$zplug_home"
then
	zplug plugins/sudo, from:oh-my-zsh
	zplug zsh-users/zsh-autosuggestions

	zplug b4b4r07/enhancd, use:init.sh
	if zplug check b4b4r07/enhancd
	then
		export ENHANCD_COMMAND=cd
		export ENHANCD_DOT_ARG='.'
	fi

	zplug plugins/macos, from:oh-my-zsh, if:'[ "$(uname)" = "Darwin" ]'

	zplug plugins/ripgrep, from:oh-my-zsh, lazy:true
	zplug plugins/fd, from:oh-my-zsh, lazy:true
	zplug plugins/aws, from:oh-my-zsh, lazy:true
	if zplug check plugins/aws
	then
		export SHOW_AWS_PROMPT=false
	fi

	# Install plugins if there are plugins that have not been installed
	if ! zplug check --verbose
	then
		printf 'Install? [y/N]: '
		if read -q
		then
			echo
			zplug install
		fi
	fi

	# Then, source plugins and add commands to $PATH
	zplug load

	# Undo the prompt changes by the aws plugin.
	#export PROMPT="$prompt_before"
	#unset RPROMPT
fi
