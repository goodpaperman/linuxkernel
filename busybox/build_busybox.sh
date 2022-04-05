#! /bin/sh
if [ ! -f busybox-1.35.0.tar.bz2 ]; then 
    wget https://www.busybox.net/downloads/busybox-1.35.0.tar.bz2
fi

if [ ! -d busybox-1.35.0 ]; then 
    tar xjvf busybox-1.35.0.tar.bz2
fi

cd busybox-1.35.0

if [ ! -f .config ]; then 
    make defconfig
    #select 'Settings->Build Options->Build BusyBox as a static binary'
    # make menuconfig
    sed -i '/CONFIG_STATIC/a\CONFIG_STATIC=y' .config
fi

if [ ! -f busybox ]; then 
    make -j4
fi

if [ -d ../kernel/fs/img ]; then 
    # setup kernel init program
    make CONFIG_PREFIX=../../kernel/fs/img install
fi
