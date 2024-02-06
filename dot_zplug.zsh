# https://github.com/zplug/zplug
# curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh

zplug_home="$HOME/.zplug/init.zsh"
if [[ -f $zplug_home ]] && source "$zplug_home"
then
	zplug plugins/sudo, from:oh-my-zsh, lazy:true
	zplug plugins/fzf, from:oh-my-zsh
	zplug plugins/magic-enter, from:oh-my-zsh
	zplug plugins/starship, from:oh-my-zsh, lazy:true
	zplug zsh-users/zsh-autosuggestions, lazy:true

	zplug b4b4r07/enhancd, use:init.sh
	zplug plugins/macos, from:oh-my-zsh, if:'[ "$(uname)" = "Darwin" ]'

	zplug plugins/ripgrep, from:oh-my-zsh, lazy:true
	zplug plugins/fd, from:oh-my-zsh, lazy:true
	zplug plugins/aws, from:oh-my-zsh, lazy:true
	zplug plugins/git-commit, from:oh-my-zsh, lazy:true
	zplug plugins/git-escape-magic, from:oh-my-zsh, lazy:true
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
fi
