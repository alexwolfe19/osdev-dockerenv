all: i386 arm aarch64 x86_64
all-fresh: fresh all

fresh:
	rm -rf res
	mkdir res
	git clone git://sourceware.org/git/binutils-gdb.git ./res/binutils
	git clone git://gcc.gnu.org/git/gcc.git ./res/gcc

clean:
	rm -rf res
	mkdir res

i386: res/binutils res/gcc
	docker build . --tag osdev-i686--build-arg TARGET="i686-elf" 

arm: res/binutils res/gcc
	docker build . --tag osdev-arm --build-arg TARGET="arm-none-eabi" 

aarch64: res/binutils res/gcc
	docker build . --tag osdev-aarch64 --build-arg TARGET="aarch64-none-elf" 


x86_64: res/binutils res/gcc
	docker build . --tag osdev-x86_64 --build-arg TARGET="x86_64-elf" 

res/binutils:
	git clone git://sourceware.org/git/binutils-gdb.git ./res/binutils
res/gcc:
	git clone git://gcc.gnu.org/git/gcc.git ./res/gcc