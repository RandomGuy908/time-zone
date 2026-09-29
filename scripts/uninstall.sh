#!/usr/bin/env bash
set -Eeuo pipefail
INSTALL_DIR="${TIMEZONE_INSTALL_DIR:-/opt/time-zone}"
if [[ ${EUID:-$(id -u)} -ne 0 ]]; then echo "Run as root." >&2; exit 1; fi
if [[ -f "$INSTALL_DIR/docker-compose.yml" ]]; then
  (cd "$INSTALL_DIR" && docker compose down --remove-orphans) || true
fi
rm -rf "$INSTALL_DIR"
echo "Time Zone Converter has been removed. Docker itself was left installed."
