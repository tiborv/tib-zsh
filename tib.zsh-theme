local ret_status="%(?:%{$fg_bold[green]%}¬:%{$fg_bold[red]%}¬%s)%{$reset_color%}"

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

function get_kubectl_ctx() {
  local kubeconfig="$HOME/.kube/config"
  if [[ -n "$KUBECONFIG" ]]; then
    kubeconfig="$KUBECONFIG"
  fi
  if [ -f $kubeconfig ]; then
    CONTEXT=$(cat $kubeconfig | grep "current-context:" | sed "s/current-context: //")
    echo " %{$fg[blue]%}kube[%{$fg[red]%}cfg:%{$fg[white]%}$kubeconfig%{$fg[blue]%} %{$fg[red]%}ctx:%{$fg[white]%}$CONTEXT%{$fg[blue]%}]"
  fi
}

function get_host() {
  echo "%{$FG[117]%}$USER%{$FG[200]%}@%{$FG[117]%}$HOST"
}

PROMPT=$'$(get_host) $(get_pwd) $(git_prompt_info)%{$reset_color%} \n$ret_status '
RPROMPT='$(get_active_vault)$(get_kubectl_ctx)%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[cyan]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[yellow]%}✕%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}✔%{$reset_color%} "
