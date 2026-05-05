#!/usr/bin/env bash
set -euo pipefail

# Configuration
KIBOT_IMAGE="ghcr.io/inti-cmnb/kicad9_auto_full:latest"
CONFIG_FILE="polski_fc.kibot.yaml"

# Check if config file exists
if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "Error: Configuration file '$CONFIG_FILE' not found."
    echo "Please ensure it exists or update CONFIG_FILE in this script."
    exit 1
fi

# Check if Docker is available
if ! command -v docker &> /dev/null; then
    echo "Error: Docker is not installed or not in PATH."
    exit 1
fi

echo "Running KiBot using $CONFIG_FILE..."
docker run --rm \
  -v "$(pwd):/board" \
  -w /board \
  -u "$(id -u):$(id -g)" \
  -e HOME=/tmp \
  "${KIBOT_IMAGE}" \
  kibot -c "$CONFIG_FILE" "$@"
