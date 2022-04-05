all: hello

hello: hello.c
	mipsel-linux-gnu-gcc -O3 $< -o $@ --static

clean:
	rm hello
