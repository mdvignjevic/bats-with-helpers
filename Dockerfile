FROM alpine:3.12.3

LABEL maintainer="milan.vignjevic@stackpath.com" \
      version="0.0.1" \
      release-date="2021-01-08" \
      description="Dockerfile for bats testing system that includes bats test helpers."

RUN apk update && apk add --no-cache bash git ncurses && rm -rf /var/cache/apk/*

RUN git clone https://github.com/bats-core/bats-core.git bats/bats-core && \
    git clone https://github.com/ztombol/bats-support bats-test-helpers/bats-support && \
    git clone https://github.com/ztombol/bats-assert bats-test-helpers/bats-assert && \
    git clone https://github.com/thingsym/bats-assertion bats-test-helpers/bats-assertion && \
    git clone https://github.com/ztombol/bats-file bats-test-helpers/bats-file && \
    git clone https://github.com/lox/bats-mock bats-test-helpers/lox-bats-mock && \
    git clone https://github.com/grayhemp/bats-mock bats-test-helpers/grayhemp-bats-mock

WORKDIR /code

ENTRYPOINT ["/bats/bats-core/bin/bats"]

# check Dockerfile with hadolint linter
# docker run --rm -i hadolint/hadolint < Dockerfile
