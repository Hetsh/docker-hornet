FROM library/debian:stable-20201209-slim
ARG DEBIAN_FRONTEND="noninteractive"
RUN apt-get update && \
    apt-get install --assume-yes \
        ca-certificates=20190110 && \
    rm -r /var/lib/apt/lists /var/cache/apt

# App user
ARG APP_USER="hornet"
ARG APP_UID=1372
RUN useradd --uid "$APP_UID" --user-group --no-create-home --shell /sbin/nologin "$APP_USER"

# Install application
ARG CONF_DIR="/etc/hornet"
ARG APP_VERSION=0.5.6
ARG APP_ARCHIVE="HORNET-${APP_VERSION}_Linux_x86_64.tar.gz"
ADD "https://github.com/gohornet/hornet/releases/download/v$APP_VERSION/$APP_ARCHIVE" "$APP_ARCHIVE"
RUN tar --extract --file "$APP_ARCHIVE" && \
    rm "$APP_ARCHIVE" && \
    EXTRACT_DIR="${APP_ARCHIVE%.tar.gz}" && \
    mv "$EXTRACT_DIR/hornet" "/usr/bin" && \
    mkdir "$CONF_DIR" && \
    mv "$EXTRACT_DIR/"*.json "$CONF_DIR" && \
    rm -r "$EXTRACT_DIR"

# Volumes
ARG DATA_DIR="/hornet"
RUN mkdir "$DATA_DIR" && \
    chmod 750 "$CONF_DIR" "$DATA_DIR" && \
    chown -R "$APP_USER":"$APP_USER" "$CONF_DIR" "$DATA_DIR"
VOLUME ["$CONF_DIR", "$DATA_DIR"]

#      DASHBOARD API       AUTO-PEERING GOSSIP
EXPOSE 8081/tcp  14265/tcp 14626/udp    15600/tcp

USER "$APP_USER"
WORKDIR "$DATA_DIR"
ENTRYPOINT ["hornet", "-d", "/etc/hornet"]
