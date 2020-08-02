# Haskell on ARM64

This document describes building Haskell development environment on ARM64, both locally and as a Docker image.

Based on <https://www.haskell.org/ghc/blog/20200515-ghc-on-arm.html>.

## Local build

### Environment

Local build was done in the following environment:

- SBC: RockPi 4B — Rockchip RK3399, 4GB RAM
- OS: Manjaro ARM
- Kernel: 5.7.10 aarch64

### GHC

#### Pre-requisites

There are some dependencies not detected by GHC configure script, need to install them manually:

- GHC depends on `libtinfo5`, but Manjaro has version 6 deployed by default
- GHC depends on `libnuma`: <https://gitlab.haskell.org/haskell/ghcup/-/issues/58>

```sh
sudo pacman -S numactl
sudo ln -s /usr/lib/libtinfo.so.6 /usr/lib/libtinfo.so.5
```

#### Build steps

Haskell does not provide Manjaro-specific source release, but Debian one seems to work just fine after installing pre-requisites as described above.

We will be installing GHC into /opt/haskell. Alternatively, we could install it system-wide (under /usr/local by default), to do it we only need to omit --prefix /opt/haskell in configuration step.

```sh
wget https://downloads.haskell.org/\~ghc/8.10.1/ghc-8.10.1-aarch64-deb9-linux.tar.xz
tar xvf ghc-8.10.1-aarch64-deb9-linux.tar.xz
cd ghc-8.10.1

./configure --prefix /opt/haskell
time make install
```

```plaintext
...
done
make install  41.43s user 31.88s system 95% cpu 1:17.13 total
```

#### Verifying the build

```sh
/opt/haskell/bin/ghc --info
```

```plaintext
[("Project name","The Glorious Glasgow Haskell Compilation System")
 ,("LibDir","/opt/haskell/lib/ghc-8.10.1")
...
 ,("Global Package DB","/opt/haskell/lib/ghc-8.10.1/package.conf.d")
 ]
```

```sh
cat > Hello.hs <<EOF
main = putStrLn "hello world!"
EOF

/opt/haskell/bin/ghc Hello.hs
```

```plaintext
[1 of 1] Compiling Main             ( Hello.hs, Hello.o )
Linking Hello ...
```

```sh
./Hello
```

```plaintext
hello world!
```

### Cabal

```sh
git clone https://github.com/haskell/cabal.git

cd cabal
./bootstrap/bootstrap.py -d ./bootstrap/linux-8.10.1.json -w /opt/Haskell/bin/ghc
```

Wait patiently, this will take **a long time** to complete.

```plaintext
Bootstrapping finished!

The resulting cabal-install executable can be found at

   _build/bin/cabal

It have been archived for distribution in

   _build/artifacts/cabal-install-3.5.0.0-aarch64-manjaro-arm-20.07-bootstrapped.tar.xz
```

```sh
./_build/bin/cabal update
./_build/bin/cabal v2-build cabal-install
./_build/bin/cabal install cabal-install
```

## Docker image

Steps described above can be used to prepare a Docker image with the Haskell development environment.

See [`Dockerfile`](./Dockerfile) for more information. That file is based on `ubuntu:focal`, so some commands will be slightly different from what is described above, in particular the package management commands (`apt` in Ubuntu vs `pacman` in Manjaro).

To build the Docker image, use command

```sh
docker build -t haskell-dev:arm64 .
```

The image is published to Docker Hub as `iblazhko/haskell-dev:arm64`:

```sh
docker pull iblazhko/haskell-dev:arm64
```
