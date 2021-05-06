FROM library/debian:stable-20210408-slim
ARG DEBIAN_FRONTEND="noninteractive"
RUN apt-get update && \
    apt-get install --assume-yes \
        ca-certificates=20200601~deb10u2 && \
    rm -r /var/lib/apt/lists /var/cache/apt

# App user
ARG APP_USER="hornet"
ARG APP_UID=1372
RUN useradd --uid "$APP_UID" --user-group --no-create-home --shell /sbin/nologin "$APP_USER"

# Install application & Volume
ARG DATA_DIR="/hornet"
ARG APP_VERSION=1.0.1
ARG APP_ARCHIVE="HORNET-${APP_VERSION}_Linux_x86_64.tar.gz"
ADD "https://github.com/gohornet/hornet/releases/download/v$APP_VERSION/$APP_ARCHIVE" "$APP_ARCHIVE"
RUN tar --extract --file "$APP_ARCHIVE" && \
    rm "$APP_ARCHIVE" && \
    EXTRACT_DIR="${APP_ARCHIVE%.tar.gz}" && \
    mv "$EXTRACT_DIR/hornet" "/usr/bin" && \
    mkdir "$DATA_DIR" && \
    mv "$EXTRACT_DIR/"*.json "$DATA_DIR" && \
    rm -r "$EXTRACT_DIR" && \
    chmod 750 "$DATA_DIR" && \
    chown -R "$APP_USER":"$APP_USER" "$DATA_DIR"
VOLUME ["$DATA_DIR"]

#      DASHBOARD HTTP-API  AUTO-PEERING GOSSIP
EXPOSE 8081/tcp  14265/tcp 14626/udp    15600/tcp

USER "$APP_USER"
WORKDIR "$DATA_DIR"
ENTRYPOINT ["hornet"]
