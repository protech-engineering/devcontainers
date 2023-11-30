# Devcontainer/docker images for development

<!-- vscode-markdown-toc -->
* [Usage](#Usage)
* [Image variants](#Imagevariants)
* [Dockerfile nomenclature](#Dockerfilenomenclature)
	* [Folder contents](#Foldercontents)
* [Image building](#Imagebuilding)
* [Development guides](#Developmentguides)
	* [Modifying an image](#Modifyinganimage)
	* [Releasing an image](#Releasinganimage)
	* [Choosing a base image](#Choosingabaseimage)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

In this repository are archived many variants of Dockerfiles used internally at Protech Engineering to provide ready-to-go and reproducible build environments.

All images are created using VSCode devcontainers.



## <a name='Usage'></a>Usage

To use these devcontainers you have to, **ONLY THE FIRST TIME**:

1. Install docker.
2. Add your user to the `docker` (usually) group and reboot.
3. Add udev rules for accessing USB devices from a non privileged user (TBD).
4. Install VSCode.
5. Install the "Dev Containers" extension.

To use a devcontainer inside your project you have to:

1. Create a `.devcontainer` folder at the root of the project.
2. In this folder add a `devcontainer.json`, with the following content:
	```json
	{
		"image": "ghcr.io/protech-engineering/devcontainers:barearm-12.2.Rel1"
	}
	```
3. Open the command palette (`CTRL+SHIFT+P` or `F1`), search and run "Dev Containers: Reopen in Container".

## <a name='Imagevariants'></a>Image variants

| Name | Tagging convention | Latest version | Notes |
|------|--------------------|----------------|------|
| barearm | `barearm-[ARM toolchain version]` | `12.2.Rel1` | This image implements basic support for ARM bare metal targets. The latest version contains: <br><ul><li>ARM GCC 12.2.Rel1 (arm-none-eabi)</li><li>OpenOCD 0.12.0-1</li><li>st-link 1.7.0</li><li>pyocd 0.35.1</li><li>pyocd packs for ST and nRF</li><li>python 3.8 and 3.10</li><li>STM32CubeProgrammer 2.13.0 (CLI)</li><li>orbuculum 2.1.0</li><li>clangd 16.0.2</li></ul> |
| esp | *still in beta* | NA | This image inherits the ESP32 docker image and adds our default tools and devcontainer settings |
| zephyr | *still in beta* | NA | This image inherits the zephyr docker image and adds our default tools and devcontainer settings |
| hdl | *still in beta* | NA | This image inherits the `hdl-containers/impl` image and contains tools for FPGA development with an open source toolchain |

## <a name='Dockerfilenomenclature'></a>Dockerfile nomenclature

For each variant is present a folder with the corresponding name inside the root of the repository.

### <a name='Foldercontents'></a>Folder contents

Each folder contains everything that is necessary to build an image. The structure of each of these folders is of a devcontainer project (i.e. instead of using the prebuilt images, you could place the contents of this folder in your project and achieve the same result)

It normally is:

* A `.devcontainer` folder, containing:
	* A `devcontainer.json` file, which defines all the container runtime options
	* A `Dockerfile`, which defines the image contents
* A `assert.sh` file, that contains the test library used to check if all the tools are present and working inside the image
* A `test.sh` file, that contains the test suite and is executed after the image is built by the CI, before pushing it to the public.

## <a name='Imagebuilding'></a>Image building

Images are automatically built whenever a new tag is published, and are available from the GitHub Container Registry.

```sh
$ docker pull ghcr.io/protech-engineering/devcontainers:[variant]-[version]
```

A push of the tag `[variant]-[version]` triggers a build for the `[variant]` version.

Variant names and versions must not contain any `-` character (dash), because it is used as a separator between variant and version in the tag name.

## <a name='Developmentguides'></a>Development guides

### <a name='Modifyinganimage'></a>Modifying an image

> In the following text, replace `[variant]` with the image name that you are modifying (e.g. `barearm`, `esp`, `zephyr`). Remember that each variant is saved inside a folder with the same name.

1. Do the needed modifications on the specific Dockerfile
2. To test the image you can either:
	* Commit and push. The continuous integration will build your image and (if there are no errors) publish your latest modifications to the following image:
		```
		docker pull ghcr.io/protech-engineering/devcontainers:[variant]-test
		```

		> Note that the image can be used as any other inside a `devcontainer.json` file. **Be careful** however, at it will change at any new commit, so **IT MUST NOT BE USED FOR PRODUCTION**

	* Build locally:
		```bash
		$ npx @devcontainers/cli build --workspace-folder [variant]
		```

		Now you can start the image with the command:

		```bash
		$ npx @devcontainers/cli up --workspace-folder [variant]
		```

		And execute a command (for example starting a shell to explore the contents):

		```bash
		$ npx @devcontainers/cli exec --workspace-folder [variant] bash
		```

### <a name='Releasinganimage'></a>Releasing an image

At this point you should have:
1. Done all the steps described in [Modifying an image](#Modifyinganimage)
2. Verified that everything is working
3. Used the (test) image in a project for a few weeks, and not found any problems

If everything is done you can release a new stable image:

1. You should make a new commit (it can be `--allow-empty`) with an explanatory message:
	```
	Modification quick description (Main tooling version)

	* Contained tool #1 Version
	* Contained tool #2 Version
	* ....
	```

	> For an example message see commit [915f50968f28ee61fd94185b5b34c6a176447bc4](https://github.com/protech-engineering/devcontainers/commit/915f50968f28ee61fd94185b5b34c6a176447bc4)

4. Create a new tag and push it.

	**Choose the tag name very carefully!**

	The format is `[variant]-[version]` where variant is the suffix of the corresponding dockerfile and version should be chosen according to the tagging convention decided and documented [here](#image-variants).

	Note that only the `-` dash separator between variant and version is allowed. If there is more than one the image won't build.

5. Check github actions to see the progress of the automatic building that is triggered by the release creation. If everything went fine the new image is available here:

	```
	$ docker pull ghcr.io/protech-engineering/devcontainers:[variant]-[version]
	```

### <a name='Choosingabaseimage'></a>Choosing a base image

* For embedded targeted images: always choose `mcr.microsoft.com/devcontainers/base`, with the Ubuntu variant. For the version tag, use the semantic versioning, e.g. `1.0.8-jammy` or `1.0.8-ubuntu-22.04`. When choosing the ubuntu versions you must choose an LTS:
	```dockerfile
	FROM mcr.microsoft.com/devcontainers/base:1.0.8-ubuntu-22.04
	```
* If another image already exists for your purpose, (it's the case, for example, of zephyr or ESP32 images), it can be adapted to be a devcontainer by adding the following code to its `[variant]/.devcontainer/devcontainer.json` file:
	```json
	"features": {
		"ghcr.io/devcontainers/features/common-utils:2": {
			"installZsh": "true",
			"username": "vscode",
			"userUid": "1000",
			"userGid": "1000",
			"upgradePackages": "true"
		}
	},
	```
	This will add al the needed packages to make it usable as a devcontainer, even if it's not derived from a `devcontainer/base` image.