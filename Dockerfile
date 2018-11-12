FROM       node:10.11-alpine
LABEL      maintainer="Sander Bel <sander@intelliops.be>"

ARG        CRONICLE_VERSION='latest'

# Docker defaults
ENV        CRONICLE_base_app_url 'http://localhost:3012'
ENV        CRONICLE_WebServer__http_port 3012
ENV        CRONICLE_WebServer__https_port 443
ENV        CRONICLE_web_socket_use_hostnames 1
ENV        CRONICLE_server_comm_use_hostnames 1
ENV        CRONICLE_web_direct_connect 0
ENV        CRONICLE_socker_io_transports '["polling", "websocket"]'

RUN        apk add --no-cache git curl wget perl bash perl-pathtools tar \
             procps tini

RUN        adduser cronicle -D -h /opt/cronicle

WORKDIR    /opt/cronicle/

# Latest version has to be installed using root user
RUN        curl -s "https://raw.githubusercontent.com/jhuckaby/Cronicle/master/bin/install.js" | node

RUN        chown cronicle:cronicle *

USER       cronicle

RUN        mkdir -p data logs plugins

ADD        entrypoint.sh /entrypoint.sh

EXPOSE     3012

# data volume is also configured in entrypoint.sh
VOLUME     ["/opt/cronicle/data", "/opt/cronicle/logs", "/opt/cronicle/plugins"]

ENTRYPOINT ["/sbin/tini", "--"]

CMD        ["sh", "/entrypoint.sh"]
