FROM ubuntu:20.04

ARG GITHUB_REPO

RUN apt update \
    && apt install -y curl

RUN useradd \
    --create-home \
    --shell /bin/bash \
    runner

USER runner

RUN mkdir /home/runner/actions-runner 
WORKDIR /home/runner/actions-runner

RUN curl \
    -o actions-runner-linux-x64-2.296.1.tar.gz \
    -L https://github.com/actions/runner/releases/download/v2.296.1/actions-runner-linux-x64-2.296.1.tar.gz
RUN tar xzf ./actions-runner-linux-x64-2.296.1.tar.gz

USER root
RUN ./bin/installdependencies.sh

# RUN --mount=type=secret,id=GITHUB_TOKEN,uid=1000 ./config.sh \
#     --url ${GITHUB_REPO} \
#     --token $(cat /run/secrets/GITHUB_TOKEN)
USER runner
COPY create_runner.sh ./create_runner.sh

# CMD ["./run.sh"]
ENTRYPOINT ["./create_runner.sh"]