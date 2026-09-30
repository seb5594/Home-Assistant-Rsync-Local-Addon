# Replaced: ARG BUILD_FROM
# Replaced: FROM $BUILD_FROM AS RUNNING
# Replaced: FROM ghcr.io/home-assistant/base:3.24-2026.08.0
# The last release that published the Alpine base for all five architectures.
# BUILD_FROM is overridden by older Supervisors using build.yaml; newer ones
# resolve its default from BUILD_ARCH without requiring the legacy builder.
ARG BUILD_ARCH=amd64
ARG BUILD_FROM=ghcr.io/home-assistant/${BUILD_ARCH}-base:3.22-2025.11.1
FROM ${BUILD_FROM}

# Replaced: RUN apk update && \
# Replaced:     apk add --no-cache \
# Replaced:         'rsync=3.4.1' \
# Replaced:         'coreutils=9.3-r2'
# Use packages from the supported Alpine branch of the pinned base image.
RUN apk add --no-cache rsync coreutils

ARG BUILD_VERSION=1.73
ARG BUILD_ARCH
# Replaced: io.hass.type="app"
LABEL io.hass.version="${BUILD_VERSION}" \
    io.hass.type="addon" \
    io.hass.arch="${BUILD_ARCH}"

COPY root /
RUN chmod a+x /run.sh
ENTRYPOINT [ "/run.sh" ]
