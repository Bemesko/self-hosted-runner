# syntax=docker/dockerfile:1.2

FROM ubuntu:20.04

ARG GITHUB_REPO

RUN apt update
RUN apt install -y curl

RUN useradd --create-home --shell /bin/bash runner

USER runner
WORKDIR /home/runner

RUN mkdir actions-runner && cd actions-runner
RUN curl \
    -o actions-runner-linux-x64-2.296.1.tar.gz \
    -L https://github.com/actions/runner/releases/download/v2.296.1/actions-runner-linux-x64-2.296.1.tar.gz
RUN tar xzf ./actions-runner-linux-x64-2.296.1.tar.gz

USER root
RUN ./bin/installdependencies.sh

USER runner
RUN --mount=type=secret,id=GITHUB_TOKEN,uid=1000 ./config.sh \
    --url ${GITHUB_REPO} \
    --token $(cat /run/secrets/GITHUB_TOKEN)

CMD ["./run.sh"]