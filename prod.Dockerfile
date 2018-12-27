FROM elixir:1.7.4-alpine

# elixir expects utf8.
ENV ELIXIR_VERSION="v1.7.4" \
  LANG=C.UTF-8

RUN apk add --update git openssh build-base wget bash

WORKDIR /opt/app
RUN git clone https://github.com/PharosProduction/excluster /opt/app

RUN mix local.hex --force && mix local.rebar --force
RUN MIX_ENV=prod mix do deps.get, deps.compile --force
  # mix escript.install hex ex_doc && \
  # mix docs && \
  # mix test && \
  # mix dialyzer && \
  # mix credo --strict 
  #MIX_ENV=test mix cover -u -v && \

# COPY ./vm.args /opt/app/rel/vm.args/prod.vm.args
# COPY ./.hosts.erlang /opt/app/_build/prod/rel/privori_server/.hosts.erlang
# COPY ./sys.config /opt/app/sys.config


RUN  MIX_ENV=prod mix release --env=prod

ARG HOSTNAME
ENV REPLACE_OS_VARS=true \
  HOSTNAME=${HOSTNAME}

ENTRYPOINT ["/opt/app/_build/prod/rel/excluster/bin/excluster"]
CMD ["console"]