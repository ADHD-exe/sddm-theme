#!/usr/bin/env bash

set -euo pipefail

THEME_NAME="skele-gamer-qt6"
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/${THEME_NAME}"
TARGET_DIR="/usr/share/sddm/themes/${THEME_NAME}"
CONF_DIR="/etc/sddm.conf.d"
CONF_FILE="${CONF_DIR}/theme.conf"

if [[ "${EUID}" -ne 0 ]]; then
  echo "Run with sudo: sudo ./install.sh"
  exit 1
fi

if [[ ! -d "${SOURCE_DIR}" ]]; then
  echo "Theme source not found: ${SOURCE_DIR}"
  exit 1
fi

rm -rf "${TARGET_DIR}"
mkdir -p /usr/share/sddm/themes
cp -r "${SOURCE_DIR}" /usr/share/sddm/themes/

mkdir -p "${CONF_DIR}"
cat >"${CONF_FILE}" <<EOF
[Theme]
Current=${THEME_NAME}
EOF

echo "Installed ${THEME_NAME} to ${TARGET_DIR}"
echo "Active theme written to ${CONF_FILE}"
