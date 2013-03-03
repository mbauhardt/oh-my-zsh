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
   prompt_segment black default "$symbols $LAST_CMD_STATUS %h"
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
     prompt_segment yellow black "$(git_prompt_info)$(git_prompt_status)"
   else
     prompt_segment green black "$(git_prompt_info)$(git_prompt_status)"
   fi
  fi
}

space() {
  echo -n ' '
}

comma() {
  echo -n ', '
}

command_exists () {
   type "$1" &> /dev/null ;
}

prompt_system() {
  echo -n 'zsh-'$ZSH_VERSION
  if command_exists brew; then
    comma
    echo -n 'brew-'`brew --version`
  fi

  if command_exists mysql; then
    comma
    echo -n 'mysql-'`mysql --version | awk '{print $5}'`
  fi

  if command_exists git; then
    space
    echo -n 'git-'`git --version | awk '{print $3}'`
  fi

  if command_exists rvm; then  
    comma
    echo -n 'rvm-'`rvm --version 2>&1 | grep rvm | awk '{print $2}'`
  fi
}

prompt_lang() {
  if command_exists ruby; then
    echo -n 'ruby-'`ruby --version | awk '{print $2}'`
  fi

  if command_exists python; then
    comma
    echo -n 'python-'`python --version 2>&1 | awk '{print $2}'`
  fi

  if command_exists java; then
    comma
    echo -n 'java-'`java -version 2>&1 | grep version | awk '{print $3}' | sed 's/"//g'`
  fi
}

build_info_line() {
  new_line
  new_line
  echo -n '['
  prompt_system
  echo -n ']'
  echo -n ' '
  echo -n '['
  prompt_lang
  echo -n ']'
}

build_powerline() {
   new_line
   enable_bold
   prompt_command_status
   prompt_user
   prompt_dir
   prompt_git
   prompt_end
   reset_colors

   new_line
   echo -n '%# '
}

build_date_time() {
   echo -n "%{$fg[red]%} %w,%t"
   reset_colors
}

build_all_prompts() {
   LAST_CMD_STATUS=$?
   build_info_line
   build_powerline
}


PROMPT='$(build_all_prompts)'
RPROMPT='$(build_date_time)'