# linuxkernel
study linux kernel
1. setup a virtual machine (qemu) to run newly compiled linux kernel.
2. setup filesystem & command (busybox) to let user login (vnc) and type simple command on this linux kernel.
3. do a simple test by insert/remove kernel module (hello) and see output.

steps:
a) setup qemu:
    cd qemu
    sh build_qemu.sh
b) setup kernel:
    cd kernel
    sh build_kernel.sh
c) setup busybox:
    cd busybox
    sh build_busybox.sh
d) do test:
    start kernel in qemu
    login system by vnc
    do test follow steps in script

