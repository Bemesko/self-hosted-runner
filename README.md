# Self Hosted Runner

My own implementation of the GitHub self-hosted runner configuration in a
Docker image format so I can easily set up runners for my stuff.

## How to build

Run the `setup.sh` script passing the required parameters as such:

```bash
setup.sh REPO_URL GITHUB_TOKEN [DOCKER_USER]
```

- `REPO_URL` is the HTTPS URL of the GitHub repository you wish to add your runner to
- `GITHUB_TOKEN` is a GitHub API token with the `repo` permissions
- `DOCKER_USER` can optionally be passed if you wish to tag the image with your Docker username

The script will produce an image named `[docker_user]/gh-runner:[repo_name]` or simply `gh-runner:[repo_name]` if you don't pass the `DOCKER_USER` value. This process already registers your runner into the repository with the default name "buildkitsandbox" and the tags `self-hosted`, `Linux` and `X64`.

To run the resulting image you can simply call:

```bash
docker run [docker_user]/gh-runner:[repo_name]
```

## Checklist

* [X] Receive an API token insted of the repo-specific token

* [X] Make optional parameter for docker username

* [ ] Specify runner name and tags in a configuration file perhaps

* [ ] Consider adding other types of runners? (currently only supports linux x64)
