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
  echo "%{$fg[white]%}$prompt_short_dir"
}

function get_k8s_ctx() {
  local k8s_config="$HOME/.kube/config"
  if [[ -n "$k8s_config" ]]; then
    k8s_config="$k8s_config"
  fi
  if [ -f $k8s_config ]; then
    local k8s_ctx=$(cat $k8s_config | grep "current-context:" | sed "s/current-context: //")
    echo "%{$fg[blue]%}k8s[%{$fg[red]%}cfg:%{$fg[white]%}$k8s_config%{$fg[blue]%} %{$fg[red]%}ctx:%{$fg[white]%}$k8s_ctx%{$fg[blue]%}]"
  fi
}

function get_host() {
  echo "%{$FG[117]%}$USER%{$FG[200]%}@%{$FG[117]%}$HOST"
}

PROMPT=$'$(get_k8s_ctx) $(get_host) $(get_pwd) $(git_prompt_info)%{$reset_color%}\n¬ '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[cyan]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[yellow]%}✕%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}✔%{$reset_color%} "
