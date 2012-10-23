# original theme https://gist.github.com/3750104
# from https://github.com/agnoster
#
# vim:ft=zsh ts=2 sw=2 sts=2
#
# agnoster's Theme - https://gist.github.com/3712874
# A Powerline-inspired theme for ZSH
#
# # README
#
# In order for this theme to render correctly, you will need a
# [Powerline-patched font](https://gist.github.com/1595572).
#
# In addition, I recommend the
# [Solarized theme](https://github.com/altercation/solarized/) and, if you're
# using it on Mac OS X, [iTerm 2](http://www.iterm2.com/) over Terminal.app -
# it has significantly better color fidelity.
#
# # Goals
#
# The aim of this theme is to only show you *relevant* information. Like most
# prompts, it will only show git information when in a git working directory.
# However, it goes a step further: everything from the current user and
# hostname to whether the last call exited with an error.

new_line() {
   echo ''
}


CURRENT_BG=''
prompt_segment() {
  if [[ -n $CURRENT_BG ]]; then
    close_previous_segment $CURRENT_BG $1 
  fi
  local bg fg
  bg="%K{$1}"
  fg="%F{$2}"
  echo -n "%{$bg%}%{$fg%}"
  echo -n " "
  echo -n $3
  echo -n " "
  CURRENT_BG=$1
}


close_previous_segment() {
  local separator=$(echo -e "\xe2\xae\x80") 
  bg="%K{$2}"
  fg="%F{$1}"
  echo -n "%{$bg%}%{$fg%}"
  echo -n $separator

}


prompt_command_status() {
   local ballot_x=$(echo -e "\xe2\x9c\x98")
   local check_mark=$(echo -e "\xe2\x9c\x94")
   local symbols  
   [[ $LAST_CMD_STATUS -ne 0 ]] && symbols+="%{%F{red}%}$ballot_x"
   [[ $LAST_CMD_STATUS -eq 0 ]] && symbols+="%{%F{green}%}$check_mark"
   prompt_segment black default "$symbols"
}

reset_colors() {
   echo -n "%{%k%}"
   echo -n "%{%f%}"
}

enable_bold() {
   echo -n "%{%f%B%k%}"
}

prompt_user() {
   prompt_segment black default %n@%m
}

prompt_dir() {
  prompt_segment blue black "%~"
}

prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    close_previous_segment $CURRENT_BG default
  fi   
}


prompt_git() {

  _git_prompt_info() {
    ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="$(git show-ref --head -s --abbrev | head -n1 2> /dev/null)"
    echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_SUFFIX"
  }

  git_prompt_ahead_behind() {
    ahead=$(git rev-list origin/$(current_branch)..HEAD -- 2> /dev/null)
    behind=$(git rev-list HEAD..origin/$(current_branch) -- 2> /dev/null)
    if [[ -n $ahead && -n $behind ]]; then
      echo "$ZSH_THEME_GIT_PROMPT_DIVERGED"
    elif [[ -n $ahead ]]; then
      echo "$ZSH_THEME_GIT_PROMPT_AHEAD"
    elif [[ -n $behind ]]; then
      echo "$ZSH_THEME_GIT_PROMPT_BEHIND"
    else
      echo "$ZSH_THEME_GIT_PROMPT_UPTODATE"
    fi
  }

  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
   ZSH_THEME_GIT_PROMPT_MODIFIED=" %{$(echo -e "\xe2\x9a\x99")%}"
   ZSH_THEME_GIT_PROMPT_DELETED=" %{$(echo -e "\xe2\x9c\x98")%}"
   ZSH_THEME_GIT_PROMPT_UNTRACKED=" %{$(echo -e "\x3f")%}"
   ZSH_THEME_GIT_PROMPT_UNMERGED=" %{$(echo -e "\xe2\x9a\xa1")%}"
   ZSH_THEME_GIT_PROMPT_RENAMED=" %{$(echo -e "\xe2\x9c\x8e")%}"
   ZSH_THEME_GIT_PROMPT_ADDED=" %{$(echo -e "\xe2\x98\x85")%}"
   ZSH_THEME_GIT_PROMPT_SUFFIX=""
   ZSH_THEME_GIT_PROMPT_PREFIX="%{$(echo -e "\xc2\xb1")%}"
   ZSH_THEME_GIT_PROMPT_DIRTY=":"
   ZSH_THEME_GIT_PROMPT_CLEAN=""
   ZSH_THEME_GIT_PROMPT_AHEAD=" %{$(echo -e "\xe2\x86\x91")%}"
   ZSH_THEME_GIT_PROMPT_BEHIND=" %{$(echo -e "\xe2\x86\x93")%}"
   ZSH_THEME_GIT_PROMPT_DIVERGED=" %{$(echo -e "\xe2\x86\x95")%}"
   if [[ -n $(parse_git_dirty) ]]; then
     prompt_segment yellow black "$(_git_prompt_info)$(git_prompt_status)$(git_prompt_ahead_behind)"
   else
     prompt_segment green black "$(_git_prompt_info)$(git_prompt_status)$(git_prompt_ahead_behind)"
   fi
  fi
}


build_powerline() {
   LAST_CMD_STATUS=$?

   new_line
   new_line
   enable_bold
   prompt_command_status
   prompt_user
   prompt_dir
   prompt_git

   prompt_end

   reset_colors

   new_line
   echo -n '> '
}


PROMPT='$(build_powerline)'
