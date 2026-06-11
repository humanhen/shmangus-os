#!/bin/sh
# Build the Shmangus OS ISO.
#
# On a Debian host with live-build installed, run:  sudo ./build.sh
# On anything else with Docker installed, run:      ./build.sh docker
set -e

cd "$(dirname "$0")"

if [ "$1" = "docker" ]; then
    docker build -t shmangus-os-builder .
    exec docker run --rm --privileged \
        -v "$(pwd)":/build -w /build \
        shmangus-os-builder \
        sh -c "lb clean && lb config && lb build"
fi

if ! command -v lb >/dev/null 2>&1; then
    echo "live-build is not installed. Either run 'apt install live-build'" >&2
    echo "on a Debian system, or use './build.sh docker'." >&2
    exit 1
fi

lb clean
lb config
lb build

echo
echo "Done. ISO: $(ls shmangus-os-*.iso 2>/dev/null || echo '(build failed, see log above)')"
