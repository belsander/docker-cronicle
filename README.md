# docker-cronicle
[![Build status](https://img.shields.io/docker/build/intelliops/cronicle.svg)](https://hub.docker.com/r/intelliops/cronicle) [![Build status](https://img.shields.io/travis/belsander/docker-cronicle.svg)](https://travis-ci.org/belsander/docker-cronicle)

Docker container for a Cronicle single-server master node

# Supported tags

* `latest` [Dockerfile](https://github.com/belsander/docker-cronicle/blob/aa0367de2e7773cfef22608eeee3e019300e2400/Dockerfile)
* `letsencrypt` [Dockerfile.letsencrypt](https://github.com/belsander/docker-cronicle/blob/aa0367de2e7773cfef22608eeee3e019300e2400/Dockerfile.letsencrypt)

## latest
Latest version of Cronicle server based upon nodejs Docker image.

## letsencrypt
Same as the `latest` Docker image, but with support for Let's Encrypt
certificates. Which means that the Cronicle server can be used with SSL and a
Let's Encrypt certificate. If this is not needed, just use the tag `latest`.

# Usage

## Install
```sh
docker pull intelliops/cronicle:latest
```

## Running
```sh
docker run --name cronicle --hostname localhost -p 3012:3012 intelliops/cronicle:latest
```

Alternatively with persistent data and logs:
```sh
docker run --name cronicle \
  -v /path-to-cronicle-storage/data:/opt/cronicle/data:rw \
  -v /path-to-cronicle-storage/logs:/opt/cronicle/logs:rw \
  --hostname localhost -p 3012:3012 intelliops/cronicle:latest
```

The web UI will be available at: http://localhost:3012

> NOTE: please replace the hostname `localhost`, this is only for testing
> purposes! If you rename the hostname also consider setting the environmental
> variable `BASE_APP_URL`.

## Volumes
| Path | Description |
|--------|--------|
| /opt/cronicle/data | Volume for data |
| /opt/cronicle/logs | Volume for logs |

## Configuration

### Environmental variables
| Environmental variable | Description | Default value |
|--------|--------|--------|
| WEB_SOCKET_USE_HOSTNAMES | Setting this parameter to `1` will force Cronicle's Web UI to connect to the back-end servers using their hostnames rather than IP addresses. This includes both AJAX API calls and Websocket streams. You should only need to enable this in special situations where your users cannot access your servers via their LAN IPs, and you need to proxy them through a hostname (DNS) instead. The default is `0` (disabled), meaning connect using IP addresses.))' | 1 |
| SERVER_COMM_USE_HOSTNAMES | Setting this parameter to `1` will force the Cronicle servers to connect to each other using hostnames rather than LAN IP addresses. This is mainly for special situations where your local server IP addresses may change, and you would prefer to rely on DNS instead. The default is `0` (disabled), meaning connect using IP addresses.) | 1 |
| WEBSERVER_HTTP_PORT | The HTTP port for the web UI of your Cronicle server | 3012 |
| WEBSERVER_HTTPS_PORT | The SSL port for the web UI of your Cronicle server | 443 |
| BASE_APP_URL | A fully-qualified URL to Cronicle on your server, including the http_port if non-standard. This is used for self-referencing URLs | http://${HOSTNAME}:${WEBSERVER_HTTP_PORT} |

### Custom configuration file
A custom configuration file can be provide in the following location:
```sh
/path-to-cronicle-storage/data/config.json.import
```
The file will get loaded the very first time Cronicle is started. If afterwards
a forced reload of the custom configuration is needed remove the following file
and restart the Docker container:
```sh
/path-to-cronicle-storage/data/.setup_done
```

## Web UI credentials
The default credentials for the web interface are: `admin` / `admin`

# Reference
https://github.com/jhuckaby/Cronicle
