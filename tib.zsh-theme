local ret_status="%(?:%{$fg_bold[green]%}¬:%{$fg_bold[red]%}¬%s)"

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

function mins_to_color() { 
  COLORS=(196 202 208 220 226 148 154 118) # selection of spectrum_ls colors
  ID=$(($1 * ${#COLORS[@]} / 60.0)) # pick a index based on mins left
  IDX="${ID%.*}" # get int
  if (( IDX < ${#COLORS[@]} )); then
    (( IDX > -1)) && echo ${COLORS[IDX + 1]} || echo ${COLORS[1]}
  else 
    echo ${COLORS[-1]} 
  fi
}

function get_active_vault(){
  if [ -n "$VAULTED_ENV" ]; then
    EXP=$(date -d "$VAULTED_ENV_EXPIRATION" +%s)
    NOW=$(date -u +%s)
    DIFF=$((($EXP - $NOW) / 60)) # diff in mins
    COLOR=$(mins_to_color "$DIFF")
    (( DIFF < 0 )) && MINS_LEFT="%{$FG[$COLOR]%}✕" || MINS_LEFT="%{$FG[$COLOR]%}${DIFF}m"
    echo "%{$fg[blue]%}vaulted[%{$fg[yellow]%}$VAULTED_ENV%{$fg[blue]%}][$MINS_LEFT%{$fg[blue]%}]"
  fi
}

function get_kubectl_ctx() {
  if [[ -n "$KUBECONFIG" && -e "$KUBECONFIG" ]]; then
   CONTEXT=$(cat $KUBECONFIG | grep "current-context:" | sed "s/current-context: //")
   echo " %{$fg[blue]%}kube[%{$fg[red]%}cfg:%{$fg[white]%}$KUBECONFIG%{$fg[blue]%} %{$fg[red]%}ctx:%{$fg[white]%}$CONTEXT%{$fg[blue]%}]"
  fi
}

function get_host() {
  echo "%{$FG[117]%}$USER%{$FG[200]%}@%{$FG[117]%}$HOST"
}

PROMPT='$(get_host) $(get_pwd) $(git_prompt_info)%{$reset_color%} 
$ret_status '

RPROMPT='$(get_active_vault)$(get_kubectl_ctx)%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[cyan]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[yellow]%}✕%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}✔%{$reset_color%} "
