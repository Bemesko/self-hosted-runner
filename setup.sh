#!/bin/bash
set -e

err() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
}

get_runner_token(){
  local repo_owner="$1"
  local repo_name="$2"
  local github_token="$3"
  local json_file
  local runner_token

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

  echo $runner_token
}

build_runner_image() {
  local repo_url="$1"
  local repo_name="$2"
  local docker_user="$3"

  if [[ ! -z "$docker_user" ]]; then
    docker_user="$docker_user/"
  fi

  local image_name="${docker_user}gh-runner"

  docker build \
    --tag $image_name \
    .

  echo "[SUCCESS] Built image ${image_name}"
  echo "Use docker run ${image_name} to start your runner!"
}

main() {
  local repo_url="$1"
  local github_token="$2"
  local docker_user="$3"
  local repo_owner
  local repo_name
  local runner_token

  if [[ -z $repo_url || -z $github_token ]]; then
    err "Wrong number of arguments."
    err "Usage: setup.sh REPO_URL GITHUB_TOKEN [DOCKER_USER]"
    exit 1
  fi

  repo_owner=$(echo $repo_url | cut -d "/" -f 4)
  repo_name=$(echo $repo_url | cut -d "/" -f 5)

  get_runner_token $repo_owner $repo_name $github_token > secrets.txt
  build_runner_image $repo_url $repo_name $docker_user
}

main "$@"