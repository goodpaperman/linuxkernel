ifneq (${KERNELRELEASE},)
	obj-m := hello.o
else
	KERNEL_SOURCE := ../linux-4.17-rc2
	PWD := $(shell pwd)
	
default: 
	${MAKE} -C ${KERNEL_SOURCE} M=${PWD} modules

clean:
	${MAKE} -C ${KERNEL_SOURCE} M=${PWD} clean

endif
