# Self Hosted Runner

My own implementation of the GitHub self-hosted runner configuration in a
Docker image format so I can easily set up runners for my stuff.

## How to build

Not sure if I'll push this to Docker Hub, so here's how to build it:

```bash
 docker build -t gh-runner id=GITHUB_TOKEN,src=$(pwd)/secrets.txt .
```

- Note, you can also specify the repository by setting the GITHUB_REPO
environment variable to the URL.
- There needs to be a secrets.txt containing the GitHub token to create a new
runner on the specified repo

## Checklist

[ ] Receive a API token insted of the repo-specific token