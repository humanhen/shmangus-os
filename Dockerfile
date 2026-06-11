# Build environment for the Shmangus OS ISO (used by ./build.sh docker).
FROM debian:bookworm

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        live-build \
        debootstrap \
        debian-archive-keyring \
        xorriso \
        squashfs-tools \
        mtools \
        dosfstools \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /build
