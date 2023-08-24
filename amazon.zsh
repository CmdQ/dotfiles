# Keep only the first occurrence of each duplicated value.
# path is the array version of PATH.
typeset -U PATH path

for append in .toolbox/bin 'Library/Application Support/Coursier/bin' 'Library/Application Support/JetBrains/Toolbox/scripts'
do
	[[ -d $HOME/$append ]] && path+="$HOME/$append"
done

alias bws='brazil ws'
alias bwscreate='bws create --root'

[[ -r $HOME/.brazil_completion/zsh_completion ]] && source "$HOME/.brazil_completion/zsh_completion"

alias bb=brazil-build
alias bba='brazil-build apollo-pkg'
alias bre='brazil-runtime-exec'
# https://w.amazon.com/bin/view/EnvImprovementNinjas/BrazilRecursiveCmdParallel/
if command -v brazil-recursive-cmd-parallel &>/dev/null; then
    alias brc='brazil-recursive-cmd-parallel'
else
    alias brc='brazil-recursive-cmd'
fi
alias brb='brc brazil-build'
# Do a command in all packages.
# - Works with aliases, i.e. you can keep typing bb.
# - Prints the name of the package before giving output (no guessing).
# - Doesn't change your PWD.
bra() {
    local frame
    frame=$(printf '#%.0s' $(seq 1 30))
    for dir in $(bws show --format json | jq -r '.packages[].source_location')
    do
        (
            echo
            echo "$frame" "$(basename "$dir")" "$frame"
            cd "$dir" || return
            eval "$@"
        )
    done
    echo
}
alias bbb='bra brazil-build'
alias bbra='brb apollo-pkg'
alias bbserver='/apollo/bin/env -e WalletHEXService brazil-build server'
# Append D or DS to
# /apollo/bin/env -e WalletHEXService brazil-build server
# to have it enable debug mode.
alias -g D='-Ddebug.enable=y'
alias -g DS='-Ddebug.enable=y -Ddebug.suspend=y'

default_host_name=clouddesk

is_amazon_laptop() {
    [[ $(hostname) = *.ant.amazon.com ]]
}

is_clouddesk() {
    [[ $(hostname) = dev-dsk-$(whoami)-* ]]
}

# This saves you from running
# mwinit -o
# on your clouddesk after connecting.
# - It doesn't always work though.
# - Of course you need a valid cookie on your local to begin with.
transfer_mw_cookie() {
    is_amazon_laptop && scp {,"${1:-$default_host_name}":}~/.midway/cookie >/dev/null
}

# Transfer Midway cookie, connect to clouddesk and start tmux right away.
tunnel() {
    if is_clouddesk; then
        echo "It seems you are already on your cloud desktop."
        return
    fi

    local host
    host="${1:-$default_host_name}"

    if is_amazon_laptop; then
        pgrep -x ssh-agent >/dev/null || [[ -S $SSH_AUTH_SOCK ]] || eval "$(ssh-agent -s)"
    fi
    ssh-add -qt 1d & transfer_mw_cookie "$host"
    if command -v et >/dev/null; then
        # https://github.com/MisterTea/EternalTerminal
        et -f -t 1044:1044,5005:5005 "$@" "$host" -c 'tmux new -As0'
    else
        ssh -At -L 1044:localhost:1044 -L 5005:localhost:5005 "$@" "$host" tmux new -As0
    fi
}

# Some things about authentication:
# https://w.amazon.com/bin/view/AWSDiscovery/AWSMagellanService/Development/GettingStarted#HSetKerberosTicket
# Especially the cron job:
# crontab -e
# # Renew the kerberos ticket every 8 hours, this will extend the lifetime of
# # the ticket until the renew lifetime expires, after that this command will
# # fail to renew the ticket and you will need to interactively
# # run `kinit -f -l 10h -r 7d` with your password
# #
# # minute  hour(s)  day_of_month  month  weekday  command
# 00 00,08,16 * * * /usr/bin/kinit -R -c /tmp/krb5cc_xxxxxxx

# echo "0 0,8,16 * * 1-5 $(which kinit) -Rc $(klist -l |sed -ne"/$(whoami)/ s,$(whoami).*FILE:,,p")"

# Run kinit if it is needed only.
# - This function hides the original command.
kinit() {
    # Only override the no argument call.
    if (( $# > 0 )); then
        command kinit "$@"
    elif ! klist -s; then
        command kinit -R 2>/dev/null || command kinit -fp -l 10h -r 7d
    fi
}

# Run mwinit if it is needed only.
# - This function hides the original command.
# - Adds -o or -s depending on where it is run.
mwinit() {
    # Only override the no argument call.
    if (( $# > 0 )); then
        command mwinit "$@"
    elif ! command mwinit -l |grep -F "$HOME/.midway/cookie" >/dev/null; then
        is_amazon_laptop || OFLAG=-o
        command mwinit "$OFLAG" -s --aea "$@"
    fi
}

# Single command for both authorizations.
mkinit() {
    kinit
    mwinit
}

# Brazil needs an x86_64 perl, which macOS does not provide, so
#   brew install perl
# By default non-brewed cpan modules are installed to the Cellar. If you wish
# for your modules to persist across updates we recommend using `local::lib`.
# You can set that up like this:
#   PERL_MM_OPT="INSTALL_BASE=$HOME/perl5" cpan local::lib
[[ -x "$(brew --prefix)/bin/perl" ]] && [[ -d $HOME/perl5 ]] && eval "$(perl "-I$HOME/perl5/lib/perl5" "-Mlocal::lib=$HOME/perl5")"

export BRAZIL_WORKSPACE_DEFAULT_LAYOUT=short
export AUTO_TITLE_SCREENS=NO
export AWS_EC2_METADATA_DISABLED=true
export AWS_REGION=us-west-2
