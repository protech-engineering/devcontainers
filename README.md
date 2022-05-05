# Devcontainer/docker images for development

In this repository are archived many variants of Dockerfiles used internally at Protech Engineering to provide ready-to-go and reproducible build environments.

All Dockerfiles inherit from Microsoft devcontainer images, for better integration with VScode.

Different image variants are identified by the suffix in each `Dockerfile`.

## Image variants

| Name | Tagging convention | Notes |
|------|--------------------|-------|
| barearm | `barearm-[ARM toolchain version]` | This image implements basic support for ARM bare metal targets. Usually contains GCC, OpenOCD, PyOCD, st-link |

## Image building

Images are automatically built whenever a new release is published, and are available from the GitHub Container Registry.

```sh
$ docker pull ghcr.io/protech-engineering/devcontainers:[variant]-[tag]
```

A release with tag `[variant]-[version]` triggers a build for the `[variant]` version.

Variant names and versions must not contain any `-` character (dash), because it is used as a separator between variant and version in the tag name.