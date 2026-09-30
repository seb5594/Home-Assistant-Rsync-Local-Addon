ARG BUILD_FROM=alpine:20260805
FROM ${BUILD_FROM}

# Edge supplies the requested package revisions; do not mix Alpine branches.
RUN apk add --no-cache \
    bash jq \
    'rsync=3.5.1-r0' \
    'coreutils=9.11-r1' \
    && ln -s /addon_configs /app_configs \
    && ln -s /addons /local_apps \
    && ln -s /addons /local_addons

ARG BUILD_VERSION=1.74
ARG BUILD_ARCH
LABEL io.hass.version="${BUILD_VERSION}" \
    io.hass.type="addon" \
    io.hass.arch="${BUILD_ARCH}" \
    org.opencontainers.image.source="https://github.com/seb5594/Home-Assistant-Rsync-Local-Addon"

COPY root/run.sh /run.sh
RUN chmod 0755 /run.sh
ENTRYPOINT [ "/bin/bash", "/run.sh" ]
