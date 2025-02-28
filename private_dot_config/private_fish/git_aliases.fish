abbr -a g git

abbr -a ga git add
abbr -a gaa git add --all
abbr -a gapa git add --patch

abbr -a gb git branch
abbr -a gbd git branch -d
abbr -a gbD git branch -D

abbr -a gc git commit -v
abbr -a gca git commit -v -a
abbr -a gc! git commit -v --amend
abbr -a gcn! git commit -v --no-edit --amend
abbr -a gca! git commit -v -a --amend
abbr -a gcan! git commit -v -a --no-edit --amend

abbr -a gcb git checkout -b
abbr -a gcl git clone --recurse-submodules
abbr -a gcd git checkout develop
abbr -a gco git checkout

abbr -a gd git diff
abbr -a gds git diff --staged
abbr -a gdt git difftool
abbr -a gdts git difftool --staged

abbr -a gf git fetch
abbr -a gl git pull
abbr -a gp git push
abbr -a gpf git push --force-with-lease

abbr -a gignore git update-index --assume-unchanged
abbr -a gunignore git update-index --no-assume-unchanged

abbr -a gk gitk --all --branches

abbr -a glg git log --stat
abbr -a glgp git log --stat -p
abbr -a glgg git log --graph
abbr -a glgga git log --graph --decorate --all
abbr -a glo git log --oneline --decorate
abbr -a glog git log --oneline --decorate --graph
abbr -a gloga git log --oneline --decorate --graph --all

abbr -a gm git merge
abbr -a gmt git mergetool --no-prompt
abbr -a gma git merge --abort

abbr -a grb git rebase --update-refs
abbr -a grba git rebase --abort
abbr -a grbc git rebase --continue
abbr -a grbi git rebase --update-refs -i

abbr -a grh git reset
abbr -a grhh git reset --hard

abbr -a grs git restore
abbr -a grst git restore --staged

abbr -a grw git review --yes

abbr -a gss git status -sb
abbr -a gst git status

abbr -a gsta git stash push
abbr -a gstaa git stash apply
abbr -a gstd git stash drop
abbr -a gstl git stash list
abbr -a gstp git stash pop

abbr -a gsw git switch
abbr -a gswc git switch -c

# Check if gerrit exists instead of master
function git_remote_name
	for remote in (git remote)
		if string match -q "*gerrit*" $remote
			echo $remote
			return
		end
	end
	echo origin
end

# Check if main exists and use instead of master
function git_main_branch
	if not git rev-parse --is-inside-work-tree &>/dev/null
		return
	end

	for branch in master main mainline trunk
		if git show-ref -q --verify "refs/heads/$branch"
			echo $branch
			return
		end
	end
	echo master
end

alias gcm="git checkout (git_main_branch)"
alias gpsup="git push --set-upstream (git_remote_name) (git_current_branch)"
alias gke="\gitk --all (git log -g --pretty=%h)"
alias gmom="git merge (git_remote_name)/(git_main_branch)"
alias gmum="git merge upstream/(git_main_branch)"
alias grbm="git rebase --update-refs (git_main_branch)"
alias grbom="git rebase --update-refs (git_remote_name)/(git_main_branch)"
