
function antw {
  if [[ -z $ANTW_HOME ]]; then
    ANTW_HOME=$HOME/.antw/install
  fi

  $ANTW_HOME/bin/antw $@
}

compdef _ant antw

