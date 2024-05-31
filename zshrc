export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="agnostercust"

export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

plugins=(git zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh
source $HOME/.zshenv
source $HOME/aws.bashrc

alias om='overmind'
alias oms='overmind start'
alias omst='overmind stop'
alias omrs='overmind restart'
alias omc='overmind connect'

unalias g
function g() {
  local default_branch=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@');
  if [[ "$1" = "co" || "$1" = "merge" ]]; then
    if [[ "$1" = "co" && "$2" = "master" ]]; then
      git co "$default_branch";
    elif [[ "$1" = "co" ]]; then
      git "$@" 2> /dev/null;
    fi
    if [[ "$1" = "merge" && "$2" = "master" ]]; then
      git merge "$default_branch";
    elif [[ "$1" = "merge" ]]; then
      git merge "$2"
    fi
  else
    git "$@" 2> /dev/null;
  fi
}

unalias gbr
function gbr() {
  g co master;
  git pull;
  git switch -c "$1";
}

unalias gp
function gp() {
  local current_branch=$(git branch --show-current);
  git push -u origin "$current_branch";
}

function gu() {
  local current_branch=$(git branch --show-current);
  git pull origin "$current_branch";
}

function gcp() {
  git cp "$1";
}

function spec() {
  bin/rspec --format=doc "$1" # --seed $2
}

alias tks="tmux kill-session"
ctags=/opt/homebrew/bin/ctags

alias ot='ssh -o "ServerAliveInterval=60" -o "ServerAliveCountMax=60" -fNg -L 5433:squake-production.cg16txouae0e.eu-central-1.rds.amazonaws.com:5432 root@bastion.squake.earth'
alias pdb='psql -h 127.0.0.1 -p 5433 -U squake_production_readonly -d squake_production'

declare -A gh_names
gh_names=( [lud]=swiknaba [grig]=morozRed [chris]=puckzxz [me]='@me' [yury]=erofeevyurysquake )
function pra() {
  IFS=','
  local assignee_names=''
  names=(${(@s:,:)2})
  for name in "${names[@]}";
  do
    if [[ "$assignee_names" = '' ]]; then
      assignee_names="${gh_names[$name]}"
    else
      assignee_names="$assignee_names,${gh_names[$name]}"
    fi
  done
  gh pr edit $1 --add-assignee $assignee_names
}

function prd() {
  IFS=','
  local assignee_names=''
  names=(${(@s:,:)2})
  for name in "${names[@]}";
  do
    if [[ "$assignee_names" = '' ]]; then
      assignee_names="${gh_names[$name]}"
    else
      assignee_names="$assignee_names,${gh_names[$name]}"
    fi
  done
  gh pr edit $1 --remove-assignee $assignee_names
}

function pram() {
  pra $1 me
}

function prall() {
  pra $1 lud,grig,chris
  gh pr edit $1 --remove-assignee "@me"
}

function prl() {
  gh pr list --author "@me"
}

function prre() {
  prd $1 lud,grig,chris
  praall $1
}
