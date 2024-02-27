FROM ubuntu:24.04
LABEL maintainer="Ivan Blazhko <iblazhko@fastmail.in>"

ARG GHC=9.8.1
ARG HLS=2.6.0
ARG CABAL=latest

ARG DEBIAN_FRONTEND=noninteractive

ENV TZ=Europe/London

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
    curl \
    libnuma-dev \
    zlib1g-dev \
    libgmp-dev \
    libgmp10 \
    git \
    wget \
    lsb-release \
    software-properties-common \
    gnupg2 \
    apt-transport-https \
    gcc \
    autoconf \
    automake \
    build-essential

RUN curl https://downloads.haskell.org/~ghcup/$(arch)-linux-ghcup > /usr/local/bin/ghcup && \
    chmod +x /usr/local/bin/ghcup

RUN useradd -ms /bin/bash haskell-dev
USER haskell-dev

RUN ghcup install ghc --force ${GHC} && \
    ghcup install cabal --force ${CABAL} && \
    ghcup install hls --force ${HLS}

RUN mkdir -p /home/haskell-dev/.config/cabal && \
    echo '' > /home/haskell-dev/.config/cabal/config && \
    ln -s /home/haskell-dev/.ghcup/bin/ghc-${GHC} /home/haskell-dev/.ghcup/bin/ghc && \
    ln -s /home/haskell-dev/.ghcup/bin/ghci-${GHC} /home/haskell-dev/.ghcup/bin/ghci && \
    ln -s /home/haskell-dev/.ghcup/bin/haddoc-${GHC} /home/haskell-dev/.ghcup/bin/haddoc && \
    ln -s /home/haskell-dev/.ghcup/bin/hp2ps-${GHC} /home/haskell-dev/.ghcup/bin/hp2ps && \
    ln -s /home/haskell-dev/.ghcup/bin/hpc-${GHC} /home/haskell-dev/.ghcup/bin/hpc && \
    ln -s /home/haskell-dev/.ghcup/bin/hsc2hs-${GHC} /home/haskell-dev/.ghcup/bin/hsc2hs && \
    ln -s /home/haskell-dev/.ghcup/bin/runghc-${GHC} /home/haskell-dev/.ghcup/bin/runghc && \
    ln -s /home/haskell-dev/.ghcup/bin/runhaskell-${GHC} /home/haskell-dev/.ghcup/bin/runhaskell && \
    /home/haskell-dev/.ghcup/bin/cabal update && \
    echo 'export PATH="$HOME/.ghcup/bin:$PATH"' >> /home/haskell-dev/.bashrc

ENTRYPOINT [ "/bin/bash" ]
