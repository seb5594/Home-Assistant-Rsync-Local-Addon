ARG BUILD_FROM=ghcr.io/seb5594/home-assistant-base:3.24-2026.11.0

FROM ${BUILD_FROM}

RUN apk add --no-cache rsync coreutils \
    && ln -s /addon_configs /app_configs \
    && ln -s /addons /local_apps \
    && ln -s /addons /local_addons

ARG BUILD_VERSION=1.75.1
LABEL io.hass.version="${BUILD_VERSION}" \
    io.hass.type="addon" \
    org.opencontainers.image.title="Home Assistant App: Rsync Local" \
    org.opencontainers.image.version="${BUILD_VERSION}" \
    org.opencontainers.image.source="https://github.com/seb5594/Home-Assistant-Rsync-Local-Addon"

COPY rootfs /
RUN chmod a+x /usr/local/bin/rsync-local \
    /etc/s6-overlay/s6-rc.d/rsync-local/run \
    /etc/s6-overlay/s6-rc.d/rsync-local/finish
