#!/bin/bash
err() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
}

get_runner_token(){
  local github_user="$1"
  local github_repo="$2"
  local github_token="$3"
  local json_file
  local runner_token

  json_file=$(mktemp)

  curl -X POST -H "Accept: application/vnd.github+json" -H "Authorization: Bearer ${github_token}" \
  -o "$json_file" --silent \
  https://api.github.com/repos/"${github_user}"/"${github_repo}"/actions/runners/registration-token

  runner_token=$(jq -r '.token' "$json_file")

  if [[ "$runner_token" == "null" ]]; then
    err "Couldn't retrieve GitHub token."
    err "JSON Response:"
    err $(cat $json_file)
    exit 1
  fi

  echo $runner_token
}

build_runner_image() {
  local github_user="$1"
  local github_repo="$2"
  local repo_url="https://github.com/${github_user}/${github_repo}"

  docker build \
    --tag "gh-runner:${github_repo}" \
    --build-arg GITHUB_REPO=${repo_url} \
    --secret id=GITHUB_TOKEN,src=$(pwd)/secrets.txt \
    .

  echo "Built image gh-runner:${github_repo}"
}

main() {
  local github_user="$1"
  local github_repo="$2"
  local github_token="$3"
  local runner_token

  if [[ -z $github_user || -z $github_repo || -z $github_token ]]; then
    err "Wrong number of arguments."
    err "Usage: setup.sh GITHUB_USER GITHUB_REPO GITHUB_TOKEN"
    exit 1
  fi

  get_runner_token $github_user $github_repo $github_token > secrets.txt
  build_runner_image $github_user $github_repo
}

set -e
main "$@"