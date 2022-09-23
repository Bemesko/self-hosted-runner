# Self Hosted Runner

My own implementation of the GitHub self-hosted runner configuration in a Docker image format so I can easily set up runners for my stuff.

## How to run

```bash
docker run bemesko/gh-runner REPO_URL GITHUB_TOKEN
```

- `REPO_URL` is the HTTPS URL of the GitHub repository you wish to add your runner to
- `GITHUB_TOKEN` is a GitHub API token with the `repo` permissions

Running this image registers a new runner into the specified repository with a random name and the tags `self-hosted`, `Linux` and `X64`.

The first job this runner will run might take a few more seconds than usual since it might detect a new github runner version and update itself.

## Checklist

* [X] Receive an API token insted of the repo-specific token

* [X] Make optional parameter for docker username

* [ ] Consider adding other types of runners? (currently only supports linux x64)
