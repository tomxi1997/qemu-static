FROM alpine:3.21

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
 bison bash xz git patch wget cmake


# required to compile Slirp as static lib and qemu-system
RUN apk add\
 util-linux-static\
 bzip2-static ncurses-static\
 libxkbcommon-static libxkbcommon-dev\
 libslirp-dev libx11-static zstd-static\
 git meson ninja-build gettext-static\ 
 libjpeg-turbo-static cyrus-sasl-static\
 build-base liburing-dev libaio-dev alpine-sdk\
 libsndfile-static libsndfile-dev openssl-libs-static\
 lz4-static pixman-static pixman-dev
 
RUN wget https://github.com/tomxi1997/qemu-static/releases/download/v1/build-static-lib.sh && \
chmod +x build-static-lib.sh && ./build-static-lib.sh
    


# additional

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
