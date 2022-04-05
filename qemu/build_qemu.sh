#! /bin/sh
sudo apt-get install ninja-build
# apt-cache search glib2 
sudo apt-get install libglib2.0-dev
sudo apt-get install libpixman-1-dev

if [ ! -d qemu ]; then 
    git clone https://gitlab.com/qemu-project/qemu.git
    cd qemu
    git submodule init
    git submodule update --recursive
else
    cd qemu
fi

if [ ! -d build ]; then 
    mkdir build
    cd build
    ../configure --prefix=/usr/local/

    make -j4
    sudo make install
fi

# test
sudo apt-get install emdebian-archive-keyring
sudo apt install linux-libc-dev-mips-cross libc6-mips-cross libc-dev-mips-cross binutils-mips-linux-gnu
sudo apt install gcc-mipsel-linux-gnu g++-mipsel-linux-gnu

mipsel-linux-gnu-gcc -O3 test/hello.c -o test/hello --static
qemu-mipsel test/hello
