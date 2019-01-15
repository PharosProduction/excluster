FROM elixir:1.7.4-alpine as builder

LABEL company="Pharos Production Inc."
LABEL version="1.0.0"

ENV LANG C.UTF-8 \
  REFRESHED_AT 2019-01-04-1 \
  TERM xterm \
  DEBIAN_FRONTEND noninteractive
ENV ELIXIR_VERSION v1.7.4

RUN apk add --update \
  git \
  build-base \
  wget \
  bash

WORKDIR /opt/$excluster_build/
COPY . /opt/$excluster_build/
# RUN wget -O - https://github.com/PharosProduction/excluster/tarball/master | tar xz \
#   && mv PharosProduction-excluster-* excluster \
#   && cd excluster

RUN mix local.hex --force && mix local.rebar --force
RUN MIX_ENV=prod mix do deps.get --only prod, deps.compile --force
RUN MIX_ENV=prod mix release --env=prod

RUN mkdir /opt/excluster \
  && tar xvzf ./_build/prod/rel/excluster/releases/1.0.0/excluster.tar.gz -C /opt/excluster
WORKDIR /opt/excluster
RUN rm -rf /opt/excluster_build
COPY ./rel/config/hosts.config ./etc/hosts.config
COPY ./rel/config/.hosts.erlang ./.hosts.erlang

CMD ["/bin/bash"]

#############################################################

FROM alpine:3.8

LABEL company="Pharos Production Inc."
LABEL version="1.0.0"

ENV LANG C.UTF-8 \
  REFRESHED_AT 2019-01-04-1 \
  TERM xterm \
  DEBIAN_FRONTEND noninteractive

ENV REPLACE_OS_VARS=true \
  HOSTNAME=${HOSTNAME} \
  ERL_CRASH_DUMP_SECONDS=10 \
  HEART_BEAT_TIMEOUT=30 \
  HEART_KILL_SIGNAL=SIGABRT \
  HEART_NO_KILL=0 \
  HEART_COMMAND=reboot

RUN apk add --update \
  bash \
  openssl

COPY --from=builder /opt/excluster /usr/local/bin/excluster
WORKDIR /usr/local/bin/excluster

CMD ["/bin/bash"]