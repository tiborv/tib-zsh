local ret_status="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ %s)"

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
  echo $prompt_short_dir
}

function get_active_vault(){
  if vaulted --version >/dev/null 2>&1; then # if vaulted exissts
    active=$(vaulted ls | sed -n -e 's/(active)//p' | sed -e 's/ //')
    if [ ! -z "$active" -a "$active" != " " ]; then
        echo " %{$fg[blue]%}vaulted[%{$fg[red]%}$active%{$fg[blue]%}]"
    fi
  fi
}

PROMPT='$ret_status$(get_active_vault) %{$fg[white]%}$(get_pwd) $(git_prompt_info)%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[cyan]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[yellow]%}✗%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}✓%{$reset_color%} "