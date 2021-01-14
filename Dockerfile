# Use different base image based on your needs, to support all shell script functionality
FROM alpine:3.12

LABEL name={NAME} \
    version={VERSION} \
    description="Docker image that contains bats-core testing system and bats test helpers"

# hadolint ignore=DL3018
RUN apk update && apk add --no-cache \
    bash \
    curl \
    git \
    ncurses \
    wget \
    && rm -rf /var/cache/apk/*

RUN git clone https://github.com/bats-core/bats-core.git /opt/bats-core
RUN git clone https://github.com/ztombol/bats-support /opt/bats-support
RUN git clone https://github.com/ztombol/bats-assert /opt/bats-assert
RUN git clone https://github.com/thingsym/bats-assertion /opt/bats-assertion
RUN git clone https://github.com/ztombol/bats-file /opt/bats-file
RUN git clone https://github.com/lox/bats-mock /opt/bats-mock-lox
RUN git clone https://github.com/grayhemp/bats-mock /opt/bats-mock-grayhemp

WORKDIR /code

ENTRYPOINT ["/opt/bats-core/bin/bats"]
