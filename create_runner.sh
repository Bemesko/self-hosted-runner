#!/bin/bash
set -e

err() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')] [ERROR] - $*" >&2
}

configure_runner() {
  local github_repo="$1"
  local github_token="$2"

  if [[ ! -f "./config.sh" ]]; then
    err "Can't configure runner because config.sh doesn't exist"
    err "This script needs a config.sh in the same directory"
    exit 1
  fi

  ./config.sh --url "${github_repo}" --token "${github_token}"
}

execute_runner() {
  if [[ ! -f "./run.sh" ]]; then
    err "Can switch runner on because run.sh doesn't exist."
    err "This script needs a run.sh in the same directory"
    exit 1
  fi

  ./run.sh
}

main() {
  local github_repo="$1"
  local github_token="$2"

  if [[ ! $# == 2 ]]; then
    err "Wrong number of arguments."
    err "Usage: create_runner.sh github_repo github_token"
    exit 1
  fi

  echo "run config.sh"
  configure_runner "${github_repo}" "${github_token}"
  echo "run run.sh"
  execute_runner
}

for item in "$@"; do
  echo "item: $item"
done

main "$@"