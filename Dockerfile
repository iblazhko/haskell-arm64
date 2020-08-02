# Image shared across all stages
FROM ubuntu:focal as common-base
RUN apt-get update && apt-get install libtinfo5 libnuma-dev -y
RUN mkdir -p /app
WORKDIR /app

# Build-time dependencies
FROM common-base as build-dependencies
RUN apt-get install build-essential llvm-9 git wget xz-utils zlib1g-dev -y

# Stage 1: GHC
FROM build-dependencies as ghc-builder-source
RUN wget -q https://downloads.haskell.org/\~ghc/8.10.1/ghc-8.10.1-aarch64-deb9-linux.tar.xz && \
    unxz ghc-8.10.1-aarch64-deb9-linux.tar.xz && \
    tar xf ghc-8.10.1-aarch64-deb9-linux.tar && \
    rm ghc-8.10.1-aarch64-deb9-linux.tar

FROM ghc-builder-source as ghc-builder
RUN cd ghc-8.10.1 && \
    ./configure && \
    make install && \
    cd .. && \
    rm -rf ghc-8.10.1

# Stage 2: Cabal
FROM ghc-builder as cabal-builder-source
RUN git clone https://github.com/haskell/cabal.git

FROM cabal-builder-source as cabal-bootstrap-builder
RUN cd /app/cabal && \
    ./bootstrap/bootstrap.py -d ./bootstrap/linux-8.10.1.json -w /usr/local/bin/ghc

FROM cabal-bootstrap-builder as cabal-builder
RUN cd /app/cabal && \
    ./_build/bin/cabal update && \
    ./_build/bin/cabal v2-build cabal-install && \
    ./_build/bin/cabal install cabal-install && \
    cd /app && \
    rm -rf cabal && \
    echo 'PATH=$PATH:$HOME/.cabal/bin; export PATH' >>$HOME/.profile
