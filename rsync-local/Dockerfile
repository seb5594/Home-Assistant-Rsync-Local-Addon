# Previous base was fixed to amd64 and lacked a published tag.
# ARG BUILD_FROM=ghcr.io/home-assistant/amd64-base:3.24
ARG BUILD_FROM=alpine:3.24.2
# BUILD_FROM is versioned here or supplied by Supervisor.
# hadolint ignore=DL3006
FROM ${BUILD_FROM}


RUN apk add --no-cache \
    bash \
    jq \
    rsync=3.5.0-r0 \
    coreutils=9.11-r0 \
    && ln -s /addon_configs /app_configs \
    && ln -s /addons /local_apps \
    && ln -s /addons /local_addons


ARG BUILD_VERSION=1.74.2
ARG BUILD_ARCH
LABEL io.hass.version="${BUILD_VERSION}" \
    io.hass.type="addon" \
    io.hass.arch="${BUILD_ARCH}" \
    org.opencontainers.image.source="https://github.com/seb5594/Home-Assistant-Rsync-Local-Addon"

COPY run.sh entrypoint.sh /
RUN chmod +x /run.sh /entrypoint.sh

#ENTRYPOINT [ "/bin/bash", "/run.sh" ]
ENTRYPOINT [ "/bin/bash", "/entrypoint.sh" ]
CMD [ "/run.sh" ]
