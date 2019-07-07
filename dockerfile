FROM debian:latest

WORKDIR /opt/work

# Setup ENV
ENV WORKSPACE="/opt/work"
ENV PREFIX="/opt/cross"
ENV PATH="${PREFIX}/bin:$PATH"

# export TARGET=i686-elf <-- must be specified when running the docker build command!

# Do update
RUN apt-get update

# Install Dependencies
    # Linux Tools
        RUN apt-get install -yq wget curl git
    # Required
        RUN apt-get install -yq build-essential
        RUN apt-get install -yq bison
        RUN apt-get install -yq flex
        RUN apt-get install -yq libgmp3-dev
        RUN apt-get install -yq libmpc-dev
        RUN apt-get install -yq libmpfr-dev
        RUN apt-get install -yq texinfo
    # Optional
        RUN apt-get install -yq libcloog-isl-dev
        RUN apt-get install -yq libisl-dev

# Download the Source Code
    RUN git clone git://sourceware.org/git/binutils-gdb.git /opt/work/binutils
    RUN git clone git://gcc.gnu.org/git/gcc.git /opt/work/gcc

# Build BinUtils
    RUN bash -c "(\
        cd ${WORKSPACE}\
        mkdir build-binutils\
        cd build-binutils\
        ../binutils/configure --target=$TARGET --prefix=\"$PREFIX\" --with-sysroot --disable-nls --disable-werror\
        make\
        make install\
    )"
# Build GCC
    RUN bash -c "(\
        cd ${WORKSPACE}\
        which -- $TARGET-as || echo $TARGET-as is not in the PATH\
        mkdir build-gcc\
        cd build-gcc\
        ../gcc-x.y.z/configure --target=$TARGET --prefix=\"$PREFIX\" --disable-nls --enable-languages=c,c++ --without-headers\
        make all-gcc\
        make all-target-libgcc\
        make install-gcc\
        make install-target-libgcc\
    )"