#!/bin/bash
set -e

THIS_DIR="$(cd "$(dirname "$0")"; pwd)"
source "$THIS_DIR/python_env/bin/activate"

if [[ -x "$THIS_DIR/pre-entry.sh" ]]; then
  echo "Sourcing pre-entry script" >&2
  source "$THIS_DIR/pre-entry.sh"
else
  echo "Skipping pre-entry script" >&2
fi

if [[ $1 == 'bash' ]]; then
    "$@"
elif [[ $1 == 'black' ]]; then
    to_process=("$THIS_DIR/service" "$THIS_DIR/manage.py")
    [[ -f "$THIS_DIR/health.py" ]] && to_process+=("$THIS_DIR/health.py")
    "$@" --target-version py39 "${to_process[@]}"
elif [[ $1 == 'pylint' ]]; then
    "$@"
else
  python "$THIS_DIR/service/helo-server.py" "$@"
fi
