FROM       node:9.11-alpine
MAINTAINER Sander Bel <sander@intelliops.be>

WORKDIR    /opt/cronicle/

ADD        entrypoint.sh /entrypoint.sh

RUN        apk add --no-cache git curl wget perl bash perl-pathtools tar\
             procps jq

RUN        curl https://letsencrypt.org/certs/lets-encrypt-x3-cross-signed.pem -o /usr/local/share/ca-certificates/LetsEncryptX3IdenTrust.crt && \
           chmod 644 /usr/local/share/ca-certificates/LetsEncryptX3IdenTrust.crt && \
           update-ca-certificates

RUN        curl -s https://raw.githubusercontent.com/jhuckaby/Cronicle/master/bin/install.js | node

EXPOSE     3012

VOLUME     ["/opt/cronicle/data", "/opt/cronicle/logs"]

CMD        ["sh", "/entrypoint.sh"]
