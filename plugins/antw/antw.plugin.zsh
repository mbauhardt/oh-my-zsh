function antw {
  if [[ -z $ANTW_HOME ]]; then
    ANTW_HOME=$HOME/.antw/install
  fi
  $ANTW_HOME/bin/antw $@
}
compdef _ant antw

function antw-update {
  if [[ -z $ANTW_HOME ]]; then
    ANTW_HOME=$HOME/.antw/install
  fi
  $ANTW_HOME/bin/antw-update
}

function antw-uninstall {
  if [[ -z $ANTW_HOME ]]; then
    ANTW_HOME=$HOME/.antw/install
  fi
  $ANTW_HOME/bin/antw-uninstall
}
