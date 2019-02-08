FROM openjdk:8-jdk

RUN echo "deb http://ftp.de.debian.org/debian testing main" >> /etc/apt/sources.list

RUN apt-get update && apt-get install -y netcat dnsutils python-kazoo python-yaml python-pip python3.7 python3-pip

ARG PULSAR_TARBALL

ADD ${PULSAR_TARBALL} /
RUN mv /apache-pulsar-* /pulsar

COPY scripts/apply-config-from-env.py /pulsar/bin
COPY scripts/gen-yml-from-env.py /pulsar/bin
COPY scripts/generate-zookeeper-config.sh /pulsar/bin
COPY scripts/pulsar-zookeeper-ruok.sh /pulsar/bin
COPY scripts/watch-znode.py /pulsar/bin
COPY scripts/set_python_version.sh /pulsar/bin
COPY scripts/install-pulsar-client-27.sh /pulsar/bin
COPY scripts/install-pulsar-client-37.sh /pulsar/bin

ADD target/python-client/ /pulsar/pulsar-client
RUN /pulsar/bin/install-pulsar-client-27.sh
RUN /pulsar/bin/install-pulsar-client-37.sh
RUN echo networkaddress.cache.ttl=1 >> $JAVA_HOME/jre/lib/security/java.security

WORKDIR /pulsar

VOLUME  ["/pulsar/conf", "/pulsar/data"]

ENV PULSAR_ROOT_LOGGER=INFO,CONSOLE