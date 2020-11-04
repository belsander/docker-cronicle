FROM       node:10.11-alpine
LABEL      maintainer="Sander Bel <sander@intelliops.be>"

ARG        CRONICLE_VERSION='0.8.28'

# Docker defaults
ENV        CRONICLE_base_app_url 'http://localhost:3012'
ENV        CRONICLE_WebServer__http_port 3012
ENV        CRONICLE_WebServer__https_port 443
ENV        CRONICLE_web_socket_use_hostnames 1
ENV        CRONICLE_server_comm_use_hostnames 1
ENV        CRONICLE_web_direct_connect 0

RUN        apk add --no-cache git curl wget perl bash perl-pathtools tar \
             procps tini

RUN        adduser cronicle -D -h /opt/cronicle

USER       cronicle

WORKDIR    /opt/cronicle/

RUN        mkdir -p data logs plugins

RUN        curl -L "https://github.com/jhuckaby/Cronicle/archive/v${CRONICLE_VERSION}.tar.gz" | tar zxvf - --strip-components 1 && \
           npm install && \
           node bin/build.js dist

ADD        entrypoint.sh /entrypoint.sh

EXPOSE     3012

# data volume is also configured in entrypoint.sh
VOLUME     ["/opt/cronicle/data", "/opt/cronicle/logs", "/opt/cronicle/plugins"]

ENTRYPOINT ["/sbin/tini", "--"]

CMD        ["sh", "/entrypoint.sh"]
