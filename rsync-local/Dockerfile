ARG BUILD_FROM=ghcr.io/seb5594/home-assistant-base:3.24-2026.11.0@sha256:d116b9e5b612e6fcd997c86642d21b61953fcbe390c39c9b03443a577ed5e2a6

# renovate: datasource=repology depName=alpine_3_24/rsync
ARG RSYNC_VERSION=3.5.2-r1
# renovate: datasource=repology depName=alpine_3_24/coreutils
ARG COREUTILS_VERSION=9.11-r0

FROM ${BUILD_FROM}

ARG RSYNC_VERSION
ARG COREUTILS_VERSION
RUN apk add --no-cache rsync=${RSYNC_VERSION} coreutils=${COREUTILS_VERSION} \
    && ln -s /addon_configs /app_configs \
    && ln -s /addons /local_apps \
    && ln -s /addons /local_addons

ARG BUILD_VERSION=1.75.1
ARG BUILD_ARCH
LABEL io.hass.version="${BUILD_VERSION}" \
    io.hass.type="addon" \
    io.hass.arch="${BUILD_ARCH}" \
    org.opencontainers.image.source="https://github.com/seb5594/Home-Assistant-Rsync-Local-Addon"

COPY rootfs /
RUN chmod a+x /usr/local/bin/rsync-local \
    /etc/s6-overlay/s6-rc.d/rsync-local/run \
    /etc/s6-overlay/s6-rc.d/rsync-local/finish
