#!/bin/bash
set -e
set -x

envdir="/code/python_env"

function env_create {
  python3 -m virtualenv -p $(which python3) "$envdir"
}
function env_install_reqs {
  [[ -e "$envdir" ]] || env_create
  if [[ -e "$1" ]]; then
    "$envdir/bin/pip" install -r "$1"
  fi
}
function pythondeps {
  env_install_reqs requirements.txt
  # env_install_reqs test-requirements.txt
}

pythondeps
