#!/usr/bin/env bash
set -Eeuo pipefail

REPO="RandomGuy908/time-zone"
INSTALL_DIR="${TIMEZONE_INSTALL_DIR:-/opt/time-zone}"
ASSET="time-zone-app.zip"
BASE="https://github.com/${REPO}/releases/latest/download"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

if [[ ${EUID:-$(id -u)} -ne 0 ]]; then
  echo "Run this installer as root (for example: curl ... | sudo bash)." >&2
  exit 1
fi

if [[ ! -r /etc/os-release ]]; then
  echo "Unsupported system: /etc/os-release was not found." >&2; exit 1
fi
. /etc/os-release
case "${ID:-}:${ID_LIKE:-}" in
  debian:*|ubuntu:*|*:debian*) ;;
  *) echo "This installer supports Debian/Ubuntu-family systems." >&2; exit 1 ;;
esac

export DEBIAN_FRONTEND=noninteractive
apt-get update -qq
apt-get install -y -qq ca-certificates curl unzip >/dev/null

if ! command -v docker >/dev/null 2>&1; then
  echo "Installing Docker Engine..."
  install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc || \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  chmod a+r /etc/apt/keyrings/docker.asc
  if [[ "${ID:-}" == "ubuntu" ]]; then DOCKER_DIST=ubuntu; else DOCKER_DIST=debian; fi
  CODENAME="${VERSION_CODENAME:-$(. /etc/os-release && echo "$VERSION_CODENAME")}" 
  ARCH="$(dpkg --print-architecture)"
  echo "deb [arch=$ARCH signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/$DOCKER_DIST $CODENAME stable" > /etc/apt/sources.list.d/docker.list
  apt-get update -qq
  apt-get install -y -qq docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin >/dev/null
fi

if ! docker compose version >/dev/null 2>&1; then
  echo "Docker Compose v2 is required." >&2; exit 1
fi
systemctl enable --now docker >/dev/null 2>&1 || true

echo "Downloading latest Time Zone Converter release..."
curl -fL "$BASE/$ASSET" -o "$TMP/$ASSET"
curl -fL "$BASE/checksums.txt" -o "$TMP/checksums.txt"
EXPECTED="$(awk '$2=="time-zone-app.zip" || $2=="*time-zone-app.zip" {print $1; exit}' "$TMP/checksums.txt")"
[[ -n "$EXPECTED" ]] || { echo "Checksum for $ASSET not found." >&2; exit 1; }
ACTUAL="$(sha256sum "$TMP/$ASSET" | awk '{print $1}')"
[[ "$EXPECTED" == "$ACTUAL" ]] || { echo "Checksum verification failed." >&2; exit 1; }

mkdir -p "$TMP/app"
unzip -q "$TMP/$ASSET" -d "$TMP/app"
mkdir -p "$INSTALL_DIR"
# Preserve the git directory if this was previously a clone; replace app files otherwise.
find "$INSTALL_DIR" -mindepth 1 -maxdepth 1 ! -name '.git' -exec rm -rf {} + 2>/dev/null || true
cp -a "$TMP/app/." "$INSTALL_DIR/"

cd "$INSTALL_DIR"
docker compose up -d --build --remove-orphans

IP="$(hostname -I 2>/dev/null | awk '{print $1}')"
echo
echo "Time Zone Converter is installed and running."
echo "Install directory: $INSTALL_DIR"
echo "URL: http://${IP:-localhost}:6030"
echo "To update later, run this installer again or run $INSTALL_DIR/scripts/update.sh"
