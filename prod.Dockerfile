FROM elixir:1.7.4-alpine

ENV ELIXIR_VERSION="v1.7.4" \
  LANG=C.UTF-8

RUN apk add --update git openssh build-base wget bash

WORKDIR /opt/app

ENV REFRESHED_AT=2018-12-27-15

COPY . /opt/app/
# RUN git clone https://github.com/PharosProduction/excluster /opt/app

RUN mix local.hex --force && mix local.rebar --force
RUN MIX_ENV=prod mix do deps.get, deps.compile --force
RUN MIX_ENV=prod mix release --env=prod

COPY ./.hosts.erlang /opt/app/_build/prod/rel/excluster/.hosts.erlang

ENV REPLACE_OS_VARS=true \
  HOSTNAME=${HOSTNAME} \
  OTP_ROOT=/opt/app/_build/prod/rel/excluster/

CMD ["/bin/bash"]