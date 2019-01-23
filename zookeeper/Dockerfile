FROM ubuntu:trusty

ARG zookeeper_version=3.4.13
ARG vcs_ref=unspecified
ARG build_date=unspecified

LABEL org.label-schema.name="zookeeper" \
  org.label-schema.description="Apache Zookeeper" \
  org.label-schema.build-date="${build_date}" \
  org.label-schema.vcs-url="https://github.com/PharosProduction/excluster" \
  org.label-schema.vcs-ref="${vcs_ref}" \
  org.label-schema.version="${zookeeper_version}" \
  org.label-schema.schema-version="1.0" \
  company="Pharos Production Inc."

ENV LANG=C.UTF-8 \
  REFRESHED_AT=2019-01-23-2 \
  ZOOKEEPER_VERSION=$zookeeper_version \
  JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64/

RUN apt-get update && apt-get install -y \
  unzip \
  openjdk-7-jre-headless \
  wget \
  supervisor \
  openssh-server

RUN echo 'root:zookeeper' | chpasswd \
  && mkdir /var/run/sshd \
  && sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

RUN wget -q http://mirror.vorboss.net/apache/zookeeper/zookeeper-$zookeeper_version/zookeeper-$zookeeper_version.tar.gz \
  && wget -q https://www.apache.org/dist/zookeeper/KEYS \
  && wget -q https://www.apache.org/dist/zookeeper/zookeeper-$zookeeper_version/zookeeper-$zookeeper_version.tar.gz.asc \
  && wget -q https://www.apache.org/dist/zookeeper/zookeeper-$zookeeper_version/zookeeper-$zookeeper_version.tar.gz.md5

RUN md5sum -c zookeeper-$zookeeper_version.tar.gz.md5 \
  && gpg --import KEYS \
  && gpg --verify zookeeper-$zookeeper_version.tar.gz.asc \
  && tar -xzf zookeeper-$zookeeper_version.tar.gz -C /opt \
  && mv /opt/zookeeper-$zookeeper_version/conf/zoo_sample.cfg /opt/zookeeper-$zookeeper_version/conf/zoo.cfg \
  && sed -i "s|/tmp/zookeeper|/opt/zookeeper-$zookeeper_version/data|g" /opt/zookeeper-$zookeeper_version/conf/zoo.cfg \
  && mkdir /opt/zookeeper-$zookeeper_version/data

COPY ./scripts/start-zk.sh /usr/bin/start-zk.sh 

WORKDIR /opt/zookeeper-$zookeeper_version
VOLUME ["/opt/zookeeper-$zookeeper_version/conf", "/opt/zookeeper-$zookeeper_version/data"]

CMD /usr/sbin/sshd \
  && bash /usr/bin/start-zk.sh