# Compiler Explorer SPARC

Builds a Docker image running awesome [Compiler Explorer](https://github.com/mattgodbolt/compiler-explorer/) with several SPARC C++ compilers.

## Compilers

 * Cobham Gaisler bcc-v2.0.1 (gcc 4.9.4)
 * Cobham Gaisler bcc-v2.0.1 (clang 4.0.0)
 * [gcc 7.3.0](/fs/tmp/ct-ng/7.3.0/.config)

The BCC cross compilers are downloaded from [Cobham Gaisler](http://www.gaisler.com/index.php/downloads/compilers). Others are built using [crosstool-ng](https://github.com/crosstool-ng/crosstool-ng).

## Build the image

Building the image will take a while. Take a look at the [Dockerfile](/Dockerfile) to see whats going on.

    docker build -t ce-sparc https://github.com/thalionath/compiler-explorer-sparc.git

## Run container

Run interactive container and map your machine’s port 80 to the container’s published port 10240 using -p:

    docker run -it -p 80:10240 ce-sparc
