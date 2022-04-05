#! /bin/sh
sudo apt-get install git fakeroot build-essential ncurses-dev xz-utils libssl-dev bc flex libelf-dev bison

#wget https://mirrors.edge.kernel.org/pub/linux/kernel/v2.6/linux-2.6.0.tar.gz
#tar xzvf linux-2.6.0.tar.gz
#cd linux-2.6.0

if [ ! -f linux-4.17-rc2.tar.gz ]; then 
    wget https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/snapshot/linux-4.17-rc2.tar.gz
    tar xzvf linux-4.17-rc2.tar.gz
fi

if [ ! -d linux-4.17-rc2 ]; then 
    tar xzvf linux-4.17-rc2.tar.gz
fi

if [ ! -f fs/disk.raw ]; then 
    mkdir fs
    qemu-img create -f raw fs/disk.raw 128G
    mkfs -t ext4 fs/disk.raw
fi

if [ ! -f linux-4.17-rc2/vmlinux ]; then 
    cd linux-4.17-rc2
    # prevent following errors:
    # #error New address family defined, please update secclass_map.
    sed -i 's%#include <sys/socket.h>%#include <linux/socket.h>%' scripts/selinux/genheaders/genheaders.c
    sed -i 's%#include <sys/socket.h>%#include <linux/socket.h>%' scripts/selinux/mdp/mdp.c
    #sed -i '2i\#include <linux/socket.h>' security/selinux/include/classmap.h

    make menuconfig
    sed -i 's/CONFIG_SYSTEM_TRUSTED_KEYS=.*/CONFIG_SYSTEM_TRUSTED_KEYS=""/' .config

    make -j4
    make bzImage
    make modules
    if [ ! -d ../fs/img ]; then 
        mkdir ../fs/img
        sudo mount -o loop ../fs/disk.raw ../fs/img
        # need at least 5G space
        sudo make modules_install INSTALL_MOD_PATH=../fs/img
    fi

    cd ..
fi

#error: Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0, 0) 
# qemu-system-x86_64 -m 512M -smp 4 -kernel arch/x86/boot/bzImage 

if [ ! -f fs/img/etc/inittab ]; then 
    sudo mkdir fs/img/etc/inittab
    sudo cp inittab fs/img/etc/
fi

if [ ! -f fs/img/etc/init.d/rcS ]; then 
    sudo mkdir fs/img/etc/init.d
    #echo "#! /bin/sh" >> fs/img/etc/init.d/rcS
    sudo cp rcS fs/img/etc/init.d/
    sudo chmod u+x fs/img/etc/init.d/rcS
fi

if [ ! -d fs/img/dev ]; then
    sudo mkdir fs/img/dev
fi

if [ ! -d fs/img/proc ]; then
    sudo mkdir fs/img/proc
fi

if [ ! -d fs/img/sys ]; then
    sudo mkdir fs/img/sys
fi

if [ ! -d fs/img/test ]; then
    sudo mkdir fs/img/test
fi

if [ ! -f fs/img/test/hello.ko ]; then 
    cd test
    # ARCH=x86 CROSS_COMPILE=x86_64-linux-gnu- make 
    make
    sudo cp hello,ko ../fs/img/test/
    # do the test after login like this:
    # cd /test
    # insmod hello.ko
    ## will see "hello world !!"
    # dmesg | tail 
    # rmmod hello.ko
    ## will see "goodbye world !!"
    # dmesg | tail 
    cd ..
fi

#error: Kernel panic - not syncing: No working init found. Try passing init= option to Kernel. See Linux Documentation/admin-guide/init.rst for guidance.
# qemu-system-x86_64 -m 512M -smp 4 -kernel arch/x86/boot/bzImage -drive format=raw,file=../fs/disk.raw -append "root=/dev/sda"
 
# need setup busybox into img
# qemu-system-x86_64 -m 512M -smp 4 -kernel arch/x86/boot/bzImage -drive format=raw,file=../fs/disk.raw -append "init=/linuxrc root=/dev/sda"

