FROM amd64/debian:stable-20221114-slim
ARG DEBIAN_FRONTEND="noninteractive"
RUN apt update && \
    apt install --assume-yes \
        ca-certificates=20210119 && \
    rm -r /var/lib/apt/lists /var/cache/apt

# App user
ARG APP_USER="hornet"
ARG APP_UID=1372
RUN useradd --uid "$APP_UID" --user-group --no-create-home --shell /sbin/nologin "$APP_USER"

# Install application
ARG APP_VERSION=1.2.1
RUN apt update && \
    apt install --no-install-recommends --assume-yes wget && \
    APP_PKG="HORNET-${APP_VERSION}_Linux_x86_64" && \
    wget --quiet "https://github.com/gohornet/hornet/releases/download/v$APP_VERSION/$APP_PKG.tar.gz" && \
    apt purge --assume-yes --auto-remove wget && \
    rm -r /var/lib/apt/lists /var/cache/apt && \
    tar --extract --strip-components=1 --directory "/usr/bin" --file "$APP_PKG.tar.gz" "$APP_PKG/hornet" && \
    rm "$APP_PKG.tar.gz"

# Volume
ARG DATA_DIR="/hornet"
RUN mkdir "$DATA_DIR" && \
    chmod 750 "$DATA_DIR" && \
    chown -R "$APP_USER":"$APP_USER" "$DATA_DIR"
VOLUME ["$DATA_DIR"]

#      DASHBOARD HTTP-API  AUTOPEERING GOSSIP
EXPOSE 8081/tcp  14265/tcp 14626/udp   15600/tcp

USER "$APP_USER"
WORKDIR "$DATA_DIR"
ENTRYPOINT ["hornet"]
