# Check if gerrit exists instead of master
git_remote_name() {
  for remote in $(git remote);
  do
    case "$remote" in
      *gerrit*)
        echo "$remote"
        return
        ;;
    esac
  done
  echo origin
}

# Check if main exists and use instead of master
git_main_branch() {
  command git rev-parse --git-dir &>/dev/null || return
  local branch
  for branch in main mainline trunk; do
    if command git show-ref -q --verify refs/heads/$branch; then
      echo $branch
      return
    fi
  done
  echo master
}

alias g='git'

alias ga='git add'
alias gaa='git add --all'
alias gapa='git add --patch'

alias gb='git branch'
alias gbd='git branch -d'
alias gbD='git branch -D'

alias gc='git commit -v'
alias gc!='git commit -v --amend'
alias gcn!='git commit -v --no-edit --amend'
alias gca='git commit -v -a'
alias gca!='git commit -v -a --amend'
alias gcan!='git commit -v -a --no-edit --amend'

alias gcb='git checkout -b'
alias gcl='git clone --recurse-submodules'
alias gcm='git checkout $(git_main_branch)'
alias gcd='git checkout develop'
alias gco='git checkout'

alias gd='git diff'
alias gds='git diff --staged'
alias gdt='git difftool'
alias gdts='git difftool --staged'

alias gf='git fetch'
alias gl='git pull'
alias gp='git push --force-with-lease'
alias gpsup='git push --set-upstream $(git_remote_name) $(git_current_branch)'

alias gignore='git update-index --assume-unchanged'
alias gunignore='git update-index --no-assume-unchanged'

alias gk='\gitk --all --branches'
alias gke='\gitk --all $(git log -g --pretty=%h)'

alias glg='git log --stat'
alias glgp='git log --stat -p'
alias glgg='git log --graph'
alias glgga='git log --graph --decorate --all'
alias glo='git log --oneline --decorate'
alias glog='git log --oneline --decorate --graph'
alias gloga='git log --oneline --decorate --graph --all'

alias gm='git merge'
alias gmom='git merge $(git_remote_name)/$(git_main_branch)'
alias gmt='git mergetool --no-prompt'
alias gmum='git merge upstream/$(git_main_branch)'
alias gma='git merge --abort'

alias grb='git rebase --update-refs'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbi='git rebase --update-refs -i'
alias grbm='git rebase --update-refs $(git_main_branch)'
alias grbom='git rebase --update-refs $(git_remote_name)/$(git_main_branch)'

alias grh='git reset'
alias grhh='git reset --hard'

alias grs='git restore'
alias grst='git restore --staged'

alias grw='git review --yes'

alias gss='git status -sb'
alias gst='git status'

alias gsta='git stash push'
alias gstaa='git stash apply'
alias gstd='git stash drop'
alias gstl='git stash list'
alias gstp='git stash pop'

alias gsw='git switch'
alias gswc='git switch -c'
