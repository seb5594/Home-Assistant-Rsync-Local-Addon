ARG BUILD_FROM=alpine:3.24.2
# hadolint ignore=DL3006
FROM ${BUILD_FROM}


RUN apk add --no-cache \
    # renovate: datasource=repology depName=alpine_3_24/bash
    bash=5.3.9-r1 \
    # renovate: datasource=repology depName=alpine_3_24/jq
    jq=1.8.2-r0 \
    # renovate: datasource=repology depName=alpine_3_24/rsync
    rsync=3.5.0-r0 \
    # renovate: datasource=repology depName=alpine_3_24/coreutils
    coreutils=9.11-r0 \
    && ln -s /addon_configs /app_configs \
    && ln -s /addons /local_apps \
    && ln -s /addons /local_addons


ARG BUILD_VERSION=1.74.4
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
