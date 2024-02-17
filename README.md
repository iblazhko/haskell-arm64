# Haskell Dev Container

This repository contains template for a Haskell project using
[Dev Containers](https://code.visualstudio.com/docs/devcontainers/containers).

[`devcontainer.json`](./.devcontainer/devcontainer.json) uses a pre-built
Docker image based on `haskell:9.8.1-slim`

Image is `iblazhko/haskell-dev:9.8.1` and it is available from Docker Hub:
<https://hub.docker.com/r/iblazhko/haskell-dev>.

```bash
 docker pull iblazhko/haskell-dev:9.8.1
```

If you need to make any modifications to the development environment,
use included [`Dockerfile`](./.devcontainer/Dockerfile) as a
starting point, modify the `Dockefile` to your liking, then build the image:

```bash
docker build -t '<tag>:<version>' .
```

and update `"image"` value in the `devcontainer.json` to use the new image.

To build multi-platform image, use following command in `.devcontainer`:

```bash
docker buildx create --name multiplatform --bootstrap --use
docker buildx build --platform linux/amd64,linux/arm64 --push --tag iblazhko/haskell-dev:9.8.1 --tag iblazhko/haskell-dev:9.8 .
```
