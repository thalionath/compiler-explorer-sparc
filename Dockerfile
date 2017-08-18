FROM ubuntu
MAINTAINER Mario Gruber <mario.gruber@space.unibe.ch>

WORKDIR /tmp

# required to run Gaisler toolchain
RUN apt-get update \
 && apt-get install -y \
    nodejs \
    npm \
    git-core \
    autoconf \
    gperf \
    bison \
    flex \
    texinfo \
    help2man \
    gawk \
    libncurses5-dev \
    wget \
 && rm -rf /var/lib/apt/lists/

WORKDIR /opt

# install Cobham Bare-C Cross-Compiler System
RUN wget -nv http://www.gaisler.com/anonftp/bcc2/bin/bcc-2.0.1-llvm-linux64.tar.bz2 \
 && echo 30d782cc97f2c0f9f8d377f29132af1d bcc-2.0.1-llvm-linux64.tar.bz2 | md5sum -c \
 && tar xf bcc-2.0.1-llvm-linux64.tar.bz2 \
 && rm bcc-2.0.1-llvm-linux64.tar.bz2

RUN wget -nv http://www.gaisler.com/anonftp/bcc2/bin/bcc-2.0.1-gcc-linux64.tar.bz2 \
 && echo dcdae0239e1d77c8b5203878e9b43724 bcc-2.0.1-gcc-linux64.tar.bz2 | md5sum -c \
 && tar xf bcc-2.0.1-gcc-linux64.tar.bz2 \
 && rm bcc-2.0.1-gcc-linux64.tar.bz2
 
# install compiler explorer
RUN git clone https://github.com/mattgodbolt/compiler-explorer.git \
 && useradd -m ce \
 && chown -R ce:ce compiler-explorer

WORKDIR /tmp
 
# install crosstool-ng to build compilers
RUN git clone https://github.com/crosstool-ng/crosstool-ng.git \
 && cd crosstool-ng \
 && ./bootstrap \
 && ./configure \
 && make \
 && make install \
 && make clean

COPY fs/ /

RUN useradd -r ctng \
 && chmod 1757 /tmp \
 && mkdir -p /tmp/ct-ng/src \
 && chown -R ctng:ctng /tmp/ct-ng \
 && mkdir -p /opt/toolchains \
 && chown ctng:ctng /opt/toolchains

WORKDIR /tmp/ct-ng/7.1.0

# ct-ng cannot run as root
RUN su ctng -p -c "ct-ng build" \
 && cd /tmp \
 && rm -rf /tmp/ct-ng

WORKDIR /opt/compiler-explorer

# allow bower to run as root
RUN echo '{ "allow_root": true }' > /root/.bowerrc \
 && make prereqs

# Make port available to the world outside this container
EXPOSE 10240
 
CMD make

