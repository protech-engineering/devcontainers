# Devcontainer/docker images for development

In this repository are archived many variants of Dockerfiles used internally at Protech Engineering to provide ready-to-go and reproducible build environments.

All Dockerfiles inherit from Microsoft devcontainer images, for better integration with VSCode and devcontainer tools.

Different image variants are identified by the suffix in each `Dockerfile`.

## Image variants

| Name | Tagging convention | Notes |
|------|--------------------|-------|
| barearm | `barearm-[ARM toolchain version]` | This image implements basic support for ARM bare metal targets. Usually contains GCC, OpenOCD, PyOCD, st-link |

## Dockerfile nomenclature

For each variant a dockerfile with name `Dockerfile.[variant]` is present in the
root folder of the repository.

## Image building

Images are automatically built whenever a new tag is published, and are available from the GitHub Container Registry.

```sh
$ docker pull ghcr.io/protech-engineering/devcontainers:[variant]-[version]
```

A push of the tag `[variant]-[version]` triggers a build for the `[variant]` version.

Variant names and versions must not contain any `-` character (dash), because it is used as a separator between variant and version in the tag name.

## Development guides

### Releasing a new version of an image

1. Do the needed modifications on the specific Dockerfile
2. Build locally:

	```bash
	$ docker build -f Dockerfile.[variant] -t [variant]-localtest . # Tag name can be whatever you want
	```

	Now the locally built image is accessible by the tag `[variant]-localtest`.

	For example you can run a shell inside this image to test that everything is working:

	```bash
	$ docker run -it --rm [variant]-localtest
	```

3. Commit and push.

	Commit message should be explanatory:

	```
	Modification quick description (Main tooling version)

	* Contained tool #1 Version
	* Contained tool #2 Version
	* ....
	```

4. Create a new tag and push it.

	Choose the tag name very carefully! The format is `[variant]-[version]` where variant is the suffix of the corresponding dockerfile and version should be chosen according to the tagging convention decided and documented [here](#image-variants).

	Note that only the `-` dash separator between variant and version is allowed. If there is more than one the image won't build.

5. Check github actions to see the progress of the automatic building that is triggered by the release creation. If everything went fine the new image is available here:

	```
	$ docker pull ghcr.io/protech-engineering/devcontainers:[variant]-[version]
	```

### Choosing a base image

* For embedded targeted images: always choose `mcr.microsoft.com/devcontainers/base`, with the Ubuntu variant. For the version tag, use the semantic versioning, e.g. `1.0.8-jammy` or `1.0.8-ubuntu-22.04`. When choosing the ubuntu versions you must choose an LTS:
	```dockerfile
	FROM mcr.microsoft.com/devcontainers/base:1.0.8-ubuntu-22.04
	```