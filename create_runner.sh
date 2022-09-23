#!/bin/bash
set -e

err() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')] [ERROR] - $*" >&2
}

get_runner_token(){
  local repo_url="$1"
  local github_token="$2"
  local repo_owner
  local repo_name
  local json_file
  local runner_token

  repo_owner=$(echo $repo_url | cut -d "/" -f 4)
  repo_name=$(echo $repo_url | cut -d "/" -f 5)

  json_file=$(mktemp)

  curl -X POST -H "Accept: application/vnd.github+json" -H "Authorization: Bearer ${github_token}" \
  -o "$json_file" --silent \
  https://api.github.com/repos/"${repo_owner}"/"${repo_name}"/actions/runners/registration-token

  runner_token=$(jq -r '.token' "$json_file")

  if [[ "$runner_token" == "null" ]]; then
    err "Couldn't retrieve GitHub token."
    err "JSON Response:"
    err $(cat $json_file)
    exit 1
  fi

  echo "$runner_token"
}

configure_runner() {
  local github_repo="$1"
  local github_token="$2"
  local runner_token

  if [[ ! -f "./config.sh" ]]; then
    err "Can't configure runner because config.sh doesn't exist"
    err "This script needs a config.sh in the same directory"
    exit 1
  fi

  runner_token=$(get_runner_token "$github_repo" "$github_token")

  ./config.sh --url "${github_repo}" --token "${runner_token}"
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

  configure_runner "${github_repo}" "${github_token}"
  execute_runner
}

main "$@"