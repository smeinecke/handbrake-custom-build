FROM ubuntu:focal

ADD assets/dpkg_nodoc /etc/dpkg/dpkg.cfg.d/90_nodoc
ADD assets/dpkg_nolocale /etc/dpkg/dpkg.cfg.d/90_nolocale
ADD assets/apt_nocache /etc/apt/apt.conf.d/90_nocache
ADD assets/apt_mindeps /etc/apt/apt.conf.d/90_mindeps

ARG DEBIAN_FRONTEND=noninteractive

# default dependencies
RUN set -e \
    && apt-get update \
    && apt-get -y install appstream autoconf automake autopoint build-essential cmake git libass-dev libbz2-dev libfontconfig1-dev libfreetype6-dev \
        libfribidi-dev libharfbuzz-dev libjansson-dev liblzma-dev libmp3lame-dev libnuma-dev libogg-dev libopus-dev libsamplerate-dev libspeex-dev \
        libtheora-dev libtool libtool-bin libturbojpeg0-dev libvorbis-dev libx264-dev libxml2-dev libvpx-dev m4 make meson nasm ninja-build patch pkg-config \
        python3 python-is-python3 tar zlib1g-dev libmp3lame-dev libnuma-dev libopus-dev libspeex-dev libvpx-dev libva-dev libdrm-dev libxml2-dev \
        libjansson-dev git debhelper-compat yasm distcc ccache wget libmfx-dev clang curl libssl-dev \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* /var/tmp/* /var/log/*

RUN set -e \
    && apt-get update \
    && apt-get -y install wget ca-certificates \
    && mkdir -p /deps \
    && wget --no-check-certificate -O /cmake-3.16.3-Linux-x86_64.tar.gz https://github.com/HandBrake/HandBrake-toolchains/releases/download/1.0/cmake-3.16.3-Linux-x86_64.tar.gz \
    && tar -C /deps -xvf /cmake-3.16.3-Linux-x86_64.tar.gz

# gtk stuff removed (gtk4 not supported in focal)

# Get Rust
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# set default
RUN cargo install cargo-c && rustup default stable

ADD bin/cargo-wrapper /root/.cargo/bin/cargo-wrapper
RUN mkdir -p /root/.cargo/bin/orig && \
    mv /root/.cargo/bin/cargo /root/.cargo/bin/orig/cargo && \
    chmod +x /root/.cargo/bin/cargo-wrapper && \
    ln -s /root/.cargo/bin/cargo-wrapper /root/.cargo/bin/cargo


ENTRYPOINT echo hello && sleep infinity