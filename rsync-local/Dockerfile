# Replaced: ARG BUILD_FROM
# Replaced: FROM $BUILD_FROM AS RUNNING
FROM ghcr.io/home-assistant/base:3.24-2026.08.0

# Replaced: RUN apk update && \
# Replaced:     apk add --no-cache \
# Replaced:         'rsync=3.4.1' \
# Replaced:         'coreutils=9.3-r2'
# Use packages from the supported Alpine branch of the pinned base image.
RUN apk add --no-cache rsync coreutils

ARG BUILD_VERSION=1.73
ARG BUILD_ARCH
LABEL io.hass.version="${BUILD_VERSION}" \
    io.hass.type="app" \
    io.hass.arch="${BUILD_ARCH}"

COPY root /
RUN chmod a+x /run.sh
ENTRYPOINT [ "/run.sh" ]
