FROM       node:12-alpine
LABEL      maintainer="Sander Bel <sander@intelliops.be>"

# Docker defaults
ENV        CRONICLE_base_app_url 'http://localhost:3012'
ENV        CRONICLE_WebServer__http_port 3012
ENV        CRONICLE_WebServer__https_port 443

# Runtime user
RUN        adduser cronicle -D -h /opt/cronicle

RUN        apk add --no-cache git curl wget perl bash perl-pathtools tar procps tini
RUN        curl -s https://raw.githubusercontent.com/jhuckaby/Cronicle/master/bin/install.js | node

WORKDIR    /opt/cronicle/
ADD        entrypoint.sh /entrypoint.sh

EXPOSE     3012

# data volume is also configured in entrypoint.sh
VOLUME     ["/opt/cronicle/data", "/opt/cronicle/logs", "/opt/cronicle/plugins"]

ENTRYPOINT ["/sbin/tini", "--"]
CMD        ["sh", "/entrypoint.sh"]