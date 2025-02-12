#! /bin/bash
#build some static lib only for qemu 9.2
WORKSPACE= /tmp/workspace
mkdir -p $WORKSPACE

#libslirp
cd $WORKSPACE
wget https://github.com/tomxi1997/qemu-static/releases/download/v1/libslirp-master.tar.gz
tar -xf libslirp-master.tar.gz
cd libslirp-master
meson setup --default-library static build 
ninja -C build install 


#libusb
cd $WORKSPACE
wget https://github.com/libusb/libusb/releases/download/v1.0.26/libusb-1.0.26.tar.bz2
tar -xjf libusb-1.0.26.tar.bz2
cd libusb-1.0.26
mkdir -p ./build ./build2
cd build
../configure
make -j8
make install
#libusb static
cd $WORKSPACE/build2
../configure --enable-static --disable-shared
make -j8
make install


#libusb-compat
cd $WORKSPACE
wget https://github.com/tomxi1997/qemu-static/releases/download/v1/libusb-compat-0.1.7.tar.bz2
tar -xf libusb-compat-0.1.7.tar.bz2
cd libusb-compat-0.1.7
mkdir build 
cd build
../configure --enable-static --disable-shared
make -j8
make install

#usbredir
cd $WORKSPACE
wget https://github.com/tomxi1997/qemu-static/releases/download/v1/usbredir-0.14.0.tar.xz
tar -xf usbredir-0.14.0.tar.xz
cd usbredir-0.14.0
mkdir build
cd build
meson setup --buildtype=release -Ddefault_library=static ..
ninja
ninja install


#fuse
cd $WORKSPACE
wget https://github.com/tomxi1997/qemu-static/releases/download/v1/fuse-3.16.2.tar.gz
tar -xf fuse-3.16.2.tar.gz
cd fuse-3.16.2
mkdir build
cd build
meson setup --buildtype=release -Ddefault_library=static ..
ninja
ninja install




#SDL2
cd $WORKSPACE
wget https://github.com/tomxi1997/qemu-static/releases/download/v1/SDL2-2.32.0.tar.gz
tar -xf SDL2-2.32.0.tar.gz
cd SDL2-2.32.0
mkdir build
cd build 
../configure --enable-static --disable-shared --enable-pulseaudio
make -j8 && make install

#SDL2_image
cd $WORKSPACE
wget https://github.com/tomxi1997/qemu-static/releases/download/v1/SDL2_image-2.8.5.tar.gz
tar -xf SDL2_image-2.8.5.tar.gz
cd SDL2_image-2.8.5
mkdir build
cd build 
../configure --enable-static --disable-shared 
make -j8 && make install

#vnc
cd $WORKSPACE
wget https://github.com/tomxi1997/qemu-static/releases/download/v1/libvncserver-LibVNCServer-0.9.15.tar.gz
tar -xf libvncserver-LibVNCServer-0.9.15.tar.gz
cd libvncserver-LibVNCServer-0.9.15
mkdir build
cd build
cmake .. -DBUILD_SHARED_LIBS=OFF
make -j8 && make install 


#clean
rm -rf $WORKSPACE
