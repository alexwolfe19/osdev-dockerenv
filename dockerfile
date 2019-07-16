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
        RUN apt-get install -y -qq wget curl git
    # Required
        RUN apt-get install -y -qq build-essential
        RUN apt-get install -y -qq bison
        RUN apt-get install -y -qq flex
        RUN apt-get install -y -qq libgmp3-dev
        RUN apt-get install -y -qq libmpc-dev
        RUN apt-get install -y -qq libmpfr-dev
        RUN apt-get install -y -qq texinfo
    # Optional
        RUN apt-get install -y -qq libcloog-isl-dev
        RUN apt-get install -y -qq libisl-dev

# Import the Source Code
    COPY ./res/binutils "${WORKSPACE}/binutils"
    COPY ./res/gcc "${WORKSPACE}/gcc"

# Build BinUtils
    RUN bash -c "(\
        cd ${WORKSPACE};\
        mkdir build-binutils;\
        cd build-binutils;\
        ../binutils/configure --target=$TARGET --prefix=\"$PREFIX\" --with-sysroot --disable-nls --disable-werror;\
        make;\
        make install;\
    )"
# Build GCC
    RUN bash -c "(\
        cd ${WORKSPACE};\
        which -- $TARGET-as || echo $TARGET-as is not in the PATH;\
        mkdir build-gcc;\
        cd build-gcc;\
        ../gcc/configure --target=$TARGET --prefix=\"$PREFIX\" --disable-nls --enable-languages=c,c++ --without-headers --disable-multilib;\
        make all-gcc;\
        make all-target-libgcc;\
        make install-gcc;\
        make install-target-libgcc;\
    )"