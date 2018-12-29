FROM alpine:3.8 

RUN apk add --update git openssh build-base wget bash openssl

WORKDIR /opt/app

ENV REFRESHED_AT=2018-12-27-18

COPY ./new-hosts.config /opt/app/hosts.config
COPY ./check.sh /opt/app/chech.sh
RUN chmod +x /opt/app/chech.sh

COPY ./.hosts.erlang /opt/app/_build/prod/rel/excluster/.hosts.erlang
COPY ./linuxhosts /etc/hosts

ENV REPLACE_OS_VARS=true \
  HOSTNAME=${HOSTNAME} \
  OTP_ROOT=/opt/app/_build/prod/rel/excluster/

CMD ["/bin/bash"]