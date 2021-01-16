# Use different base image based on the shell script needs
FROM alpine:3.12

LABEL org.opencontainers.image.title="mvignjevic/{NAME}"
LABEL org.opencontainers.image.description="Docker image that contains bats-core testing system and bats test helpers"
LABEL org.opencontainers.image.url="https://github.com/panta5/bats-with-helpers"
LABEL org.opencontainers.image.source="https://github.com/panta5/bats-with-helpers"
LABEL org.opencontainers.image.authors="Milan Vignjevic <panta5555@gmail.com>"
LABEL org.opencontainers.image.os="linux"
LABEL org.opencontainers.image.architecture="x86_64"
LABEL org.opencontainers.image.docker.cmd='docker run --rm -t -v ${PWD}:/code mvignjevic/bats-with-helpers ./tests/test-example.bats'
LABEL org.opencontainers.image.docker.debug='docker run --rm -it -v ${PWD}:/code --entrypoint /bin/sh mvignjevic/bats-with-helpers'
LABEL org.opencontainers.image.licenses="MIT"

# Install additional packages based on the shell script needs
# hadolint ignore=DL3018
RUN apk update \
    && apk add --no-cache \
    bash \
    curl \
    git \
    ncurses \
    openssl \
    wget \
    && rm -rf /var/cache/apk/*

COPY ./bats-libs /opt/bats-libs

ARG BUILD_DATE
LABEL org.opencontainers.image.version={VERSION}
LABEL org.opencontainers.image.created=${BUILD_DATE}

WORKDIR /code

ENTRYPOINT ["/opt/bats-libs/bats-core/bin/bats"]
