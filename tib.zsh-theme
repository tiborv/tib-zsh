local COLOR_BLUE="%{$fg[blue]%}"
local COLOR_RED="%{$fg[red]%}"
local COLOR_WHITE="%{$fg[white]%}"
local COLOR_YELLOW="%{$fg[yellow]%}"
local COLOR_GREEN="%{$fg[green]%}"
local COLOR_CYAN="%{$fg[cyan]%}"
local COLOR_LIGHT_CYAN="%{$FG[117]%}"
local COLOR_PINK="%{$FG[200]%}"
local RESET_COLOR="%{$reset_color%}"

function get_pwd(){
  git_root=$PWD
  while [[ $git_root != / && ! -e $git_root/.git ]]; do
    git_root=$git_root:h
  done
  if [[ $git_root = / ]]; then
    unset git_root
    prompt_short_dir=%~
  else
    parent=${git_root%\/*}
    prompt_short_dir=${PWD#$parent/}
  fi
  echo "${COLOR_WHITE}$prompt_short_dir"
}

function get_k8s_ctx() {
  local k8s_config=${KUBECONFIG:-"$HOME/.kube/config"}
  if [[ -n "$k8s_config" ]]; then
    k8s_config="$k8s_config"
  fi
  if [ -f $k8s_config ]; then
    local k8s_ctx=$(cat $k8s_config | grep "current-context:" | sed "s/current-context: //")
    echo "${COLOR_BLUE}k8s[${COLOR_RED}cfg:${COLOR_WHITE}$k8s_config${COLOR_BLUE} ${COLOR_RED}ctx:${COLOR_WHITE}$k8s_ctx${COLOR_BLUE}]"
  fi
}

function get_host() {
  echo "${COLOR_LIGHT_CYAN}$USER${COLOR_PINK}@${COLOR_LIGHT_CYAN}$HOST"
}

PROMPT='$(get_host) $(get_k8s_ctx) $(get_pwd) $(git_prompt_info)${RESET_COLOR}
> '

ZSH_THEME_GIT_PROMPT_PREFIX=$COLOR_CYAN
ZSH_THEME_GIT_PROMPT_SUFFIX=$RESET_COLOR
ZSH_THEME_GIT_PROMPT_DIRTY=" ${COLOR_YELLOW}✕"
ZSH_THEME_GIT_PROMPT_CLEAN=" ${COLOR_GREEN}✔"
