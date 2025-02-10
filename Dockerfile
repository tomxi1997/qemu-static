FROM alpine:3.21.0

RUN apk update
RUN apk upgrade

# required by qemu
RUN apk add\
 make\
 samurai\
 perl\
 python3\
 gcc\
 libc-dev\
 pkgconf\
 linux-headers\
 glib-dev glib-static\
 zlib-dev zlib-static\
 flex\
 bison


# required to compile Slirp as static lib and qemu-system
RUN apk add\
 util-linux-static\
 bzip2-static ncurses-static\
 libxkbcommon-static libxkbcommon-dev\
 libslirp-dev\
 sdl2-dev\
 libx11-static gtk+3.0-dev zstd-static\
 git meson ninja-build

RUN git clone https://gitlab.freedesktop.org/slirp/libslirp.git /tmp/libslirp && \
    cd /tmp/libslirp && \
    meson setup --default-library static build && \
    ninja -C build install && \
    rm -rf /tmp/libslirp

 # required to compile libusb as static lib
RUN git clone https://github.com/libusb/libusb.git /tmp/libusb && cd /tmp/libusb && \
 ./configure --with-pic --disable-udev --enable-static --disable-shared && make -j$(nproc) && make install && \
 rm -rf /tmp/libusb
 


# additional
RUN apk add bash xz git patch

WORKDIR /work

COPY command/base command/base
COPY command/fetch command/fetch
RUN /work/command/fetch

COPY command/extract command/extract
RUN /work/command/extract

COPY patch patch
COPY command/patch command/patch
RUN /work/command/patch

COPY command/configure command/configure
RUN /work/command/configure

COPY command/make command/make
RUN /work/command/make

COPY command/install command/install
RUN /work/command/install

COPY command/package command/package
RUN /work/command/package
