# Keep only the first occurrence of each duplicated value.
# path is the array version of PATH.
typeset -U PATH path

for append in .toolbox/bin 'Library/Application Support/Coursier/bin' 'Library/Application Support/JetBrains/Toolbox/scripts'
do
	[[ -d $HOME/$append ]] && path+="$HOME/$append"
done

alias bws='brazil ws'
alias bwscreate='bws create --root'

if command -v brazil >/dev/null
then
    complet=$(command ls "$HOME"/.toolbox/tools/brazilcli/**/brazil_completion.zsh(om[1]))
    [[ -f $complet ]] && source "$complet"
fi
# Override/cancel it's completions because they easily take over 10 s:
_brazil-build() {}
type _amazon_completions >/dev/null && _amazon_completions

alias bb=brazil-build
alias bba='brazil-build apollo-pkg'
alias bre='brazil-runtime-exec'
# https://w.amazon.com/bin/view/EnvImprovementNinjas/BrazilRecursiveCmdParallel/
if command -v brazil-recursive-cmd-parallel >/dev/null
then
    alias brc='brazil-recursive-cmd-parallel'
else
    alias brc='brazil-recursive-cmd'
fi
# Do a command in all packages.
# - Works with aliases, i.e. you can keep typing bb.
# - Prints the name of the package before giving output (no guessing).
# - Doesn't change your PWD.
bra() {
    local frame
    frame=$(printf '#%.0s' $(seq 1 30))
    for dir in $(brazil-recursive-cmd -all pwd -P 2>/dev/null)
    do
        (
            printf '\n%s %s %s\n' "$frame" "$(basename "$dir")" "$frame"
            cd "$dir" && eval "$@" || return 1
        ) || return 1
    done
    echo
}
alias bbb='bra brazil-build'
alias bbra='brb apollo-pkg'
alias bbserver='/apollo/bin/env -e WalletHEXService brazil-build server'
alias sync='ninja-dev-sync'
# Append D or DS to
# /apollo/bin/env -e WalletHEXService brazil-build server
# to have it enable debug mode.
alias -g D='-Ddebug.enable=y'
alias -g DS='-Ddebug.enable=y -Ddebug.suspend=y'

needs_cr_link() {
    ! git show -s --format=%b $1 | grep -qF 'cr: https://code.amazon.com/reviews/'
}

# Create a CR of one commit.
cr1() {
    local upsteam=origin/mainline
    if ! [[ $(git rev-parse --abbrev-ref HEAD@{upstream}) = $upsteam ]]
    then
        echo "Your branch $(git rev-parse --abbrev-ref HEAD) is not tracking $upsteam!"
        while
        do
            read "answer?Shall I change it to origin/mainline? Y/n "
            if [[ -z $answer || $answer =~ ^[Yy](es)?$ ]]
            then
                git branch --set-upstream-to="$upsteam"
                break
            elif [[ $answer =~ ^[Nn]o?$ ]]
            then
                break
            fi
        done
    fi

    args=("$@")
    if (( $# == 0 )); then
        if [[ $- = *i* ]] && command -v fzf >/dev/null; then
            selected=$( \
                git log --oneline --decorate -12 | \
                fzf +s +m --reverse --prompt 'Which commit for CR? ' \
                    --preview 'echo {} | cut -d " " -f 1 | xargs git show --color=always' | \
                cut -d ' ' -f 1
            )
            [[ -z $selected ]] && echo No selection, cancelling. && return 130
            [[ $(git log -1 --pretty=%h HEAD) = $selected ]] && needs_cr_link $selected && args+="--amend"
            cr --range "${selected}~:${selected}" "${args[@]}"
        else
            cr1 0
        fi
    else
        num=$1
        shift
        if [[ $num = 0 ]]; then
            needs_cr_link HEAD && args+="--amend"
            cr --parent HEAD~ "${args[@]}"
        elif [[ $num =~ ^[0-9]+$ ]]; then
            (( plus = $num + 1 ))
            cr --range "HEAD~${plus}:HEAD~${num}" "${args[@]}"
        else
            echo 'The first argument has to be the number of past commits to choose (0 being HEAD).'
            echo The remaining parameters are passed on to cr.
        fi
    fi
}

# Transfer Midway cookie, connect to clouddesk and start tmux right away.
tunnel() {
    if is_amazon clouddesk; then
        echo "It seems you are already on your cloud desktop."
        return
    fi

    if is_amazon laptop; then
        pgrep -x ssh-agent >/dev/null || [[ -S $SSH_AUTH_SOCK ]] || eval "$(ssh-agent -s)"
    fi
    ssh-add -qt 1d
    tmux_start=(/home/linuxbrew/.linuxbrew/bin/tmux new -As0)
    if false && command -v et >/dev/null; then
        # https://github.com/MisterTea/EternalTerminal
        et -f -t 1044:1044,5005:5005,8000:8000 "$@" etdesktop -c "$tmux_start[@]"
        # See https://w.amazon.com/bin/view/Users/Bozak/EternalTerminal/WSSH/ for the WSSH automation.
    else
        ssh -At \
            -L 1044:localhost:1044 \
            -L 5005:localhost:5005 \
            -L 8000:localhost:8000 \
            "$@" clouddesk "$tmux_start[@]"
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
    elif ! is_amazon laptop && ! klist -s; then
        # Don't run kinit on Mac anymore. Otherwise try to refresh first.
        kinit -R 2>/dev/null || kinit -fp -l 10h -r 7d
    fi
}

# Run mwinit if it is needed only.
# - This function hides the original command.
# - Adds -o depending on where it is run.
mwinit() {
    if [[ ${@[@]} =~ -d ]]; then
        command mwinit "$@"
        return
    fi

    # Only override the no argument call.
    if (( $# > 0 )); then
        args=("$@")
        if ! is_amazon laptop
        then
            args+=-o
        fi
        command mwinit "${args[@]}"

        if ! { ps -p "${SSH_AGENT_PID:-1}" | grep -q ssh-agent || [[ -S $SSH_AUTH_SOCK ]]; }
        then
            eval $(ssh-agent)
            [[ -n $SSH_AUTH_SOCK ]] || echo but isn\'t
            ssh-add 2>/dev/null
        fi
    else
        [[ -x refresh_aea.zsh ]] && refresh_aea.zsh
        if ! command mwinit -t 2>/dev/null |grep -qF 'certificate not expired'; then
            mwinit -s
        fi
    fi
}

# Single command for both authorizations.
mkinit() {
    if (( $# == 1 )) && [[ $@[1] == "-r" ]]; then
        mwinit -d
    elif (( $# > 0 )); then
        echo "mkinit only understands the -r argument to refresh (delete first)."
        return 1
    fi
    kinit
    mwinit
}

unauth() {
    eval $(ssh-agent -k)
    command mwinit --delete
    kdestroy -A
}

unittests() {
    typeset -hU dirs=()
    for dir in unit integ; do
        local name="brazil-$dir-tests"
        [[ -f build/$name/index.html ]] && dirs+=("$name")
    done
    local which
    case "${#dirs[@]}" in
        0)
            echo 'Neither unit nor integrations tests found. Are you in the root of the correct package?'
            ;;
        1)
            which=build/"${dirs[1]}"
            ;;
        *)
            cat >build/index.html <<EOF
            <!DOCTYPE html>
            <html lang="en">
            <head>
            <title>Brazil integration & unit test results</title>
            </head>
            <body>
            <h1>Brazil integration & unit test results</h1>
            <ul style="font-size: 2rem">
EOF
            for dir in "${dirs[@]}"; do
                echo "<li><a href='$dir/'>${dir#brazil-}</a></li>" >>build/index.html
            done
            echo '</ul></body></html>' >>build/index.html
            which=build
            ;;
    esac
    if is_amazon clouddesk; then
        python3 -m http.server -d "$which"
    else
        open "$which/index.html"
    fi
}

keymaster_trouble() {
    for cmd in Deactivate Preactivate Activate
    do
        sudo /apollo/bin/runCommand -a "$cmd" -e WalletHEXService.CONSUMES.KeyMasterDaemon
    done
}

wallet_ada_profiles() {
    same=(profile add --role=Operator-ReadOnly --provider=conduit)
    ada "${same[@]}" --account=620308156200 --profile=wallet+devo
    ada "${same[@]}" --account=177607377190 --profile=wallet+prod
    ada "${same[@]}" --account=000362911234 --partition=aws-cn --profile=wallet+prod+cn
    unset same
}

customer_encrypt() {
    /apollo/bin/env -e envImprovement encrypt.rb "$@"
}

customer_decrypt() {
    /apollo/bin/env -e envImprovement decrypt.rb "$@"
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
export APOLLO_STARTUP_ENVIRONMENT_ROOT=/apollo/env/WalletHEXService
export BRAZIL_PLATFORM_OVERRIDE=AL2_x86_64
export AWS_EC2_METADATA_DISABLE
export JAVA_TOOL_OPTIONS="-XX:ReservedCodeCacheSize=444M"
