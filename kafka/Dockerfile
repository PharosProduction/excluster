FROM openjdk:8u181-jre-alpine

ARG kafka_version=2.1.0
ARG scala_version=2.12
ARG glibc_version=2.28-r0
ARG kafka_home=/opt/kafka
ARG vcs_ref=unspecified
ARG build_date=unspecified

LABEL org.label-schema.name="kafka" \
  org.label-schema.description="Apache Kafka" \
  org.label-schema.build-date="${build_date}" \
  org.label-schema.vcs-url="https://github.com/PharosProduction/excluster" \
  org.label-schema.vcs-ref="${vcs_ref}" \
  org.label-schema.version="${scala_version}_${kafka_version}" \
  org.label-schema.schema-version="1.0" \
  company="Pharos Production Inc."

ENV LANG=C.UTF-8 \
  REFRESHED_AT=2019-01-23-2
ENV KAFKA_VERSION=$kafka_version \
  SCALA_VERSION=$scala_version \
  KAFKA_HOME=$kafka_home \
  GLIBC_VERSION=$glibc_version
ENV PATH=${PATH}:${KAFKA_HOME}/bin

RUN apk add --no-cache \
  bash \
  curl \
  jq

COPY ./scripts/download-kafka.sh \
  ./scripts/start-kafka.sh \
  ./scripts/broker-list.sh \
  ./scripts/create-topics.sh \
  ./scripts/versions.sh \
  /tmp/
  
RUN mkdir /opt \
  && chmod a+x /tmp/*.sh \
  && mv /tmp/start-kafka.sh \
    /tmp/broker-list.sh \
    /tmp/create-topics.sh \
    /tmp/versions.sh \
    /usr/bin \
  && sync && /tmp/download-kafka.sh \
  && tar xfz /tmp/kafka_${scala_version}-${kafka_version}.tgz -C /opt \
  && rm /tmp/kafka_${scala_version}-${kafka_version}.tgz \
  && ln -s /opt/kafka_${scala_version}-${kafka_version} /opt/kafka \
  && rm /tmp/* \
  && wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${glibc_version}/glibc-${glibc_version}.apk \
  && apk add --no-cache --allow-untrusted glibc-${glibc_version}.apk \
  && rm glibc-${glibc_version}.apk

COPY ./scripts/overrides /opt/overrides

VOLUME ["/kafka"]

CMD ["start-kafka.sh"]
