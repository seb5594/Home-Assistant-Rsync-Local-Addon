#!/bin/bash
# ==============================================================================
# Standardized Entrypoint Helper (Inspired by alexbelgium/hassio-addons)
# ==============================================================================

set -e

if command -v bashio::log.info >/dev/null 2>&1; then
    bashio::log.info "Starting Home Assistant Service..."
else
    echo "[INFO] Starting Home Assistant Service..."
fi

exec "$@"
