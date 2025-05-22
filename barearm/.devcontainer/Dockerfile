FROM ubuntu:24.04 AS orbuculum_build

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive && \
	apt-get -y install git build-essential curl libusb-1.0-0-dev libczmq-dev libncurses-dev meson libsdl2-dev libelf-dev libcapstone-dev

RUN git clone --depth 1 --branch V2.2.0 https://github.com/orbcode/orbuculum.git orbuculum_build && \
	cd orbuculum_build && meson setup --prefix=/usr build && \
	meson compile -C build && \
	DESTDIR=/orbuculum meson install -C build

FROM ubuntu:24.04 AS pyocd_pack_build

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive && \
	apt-get -y install python3-pip zip unzip && \
	pip install --break-system-packages pyocd==0.36.0

RUN pyocd pack install stm32 nrf51

RUN cd ~/.local/share/cmsis-pack-manager/ && \
	for file in $(find . -iname "*.pack"); do zipinfo -1 $file | sed '/^.*\(flm\|pdsc\|svd\|dbgconf\|sdf\)/Id' | xargs zip -d $file; done

FROM mcr.microsoft.com/devcontainers/base:1.2.6-ubuntu-24.04

RUN echo "deb https://ppa.launchpadcontent.net/deadsnakes/ppa/ubuntu noble main" >> /etc/apt/sources.list && \
	apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F23C5A6CF475977595C89F51BA6932366A755776

# Texane st-link (version 1.8.0 in repository)
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive && \
	apt-get -y install \
	make \
	bear \
	picocom \
	microcom \
	xz-utils \
	python3-pip \
	telnet \
	python3.8 \
	libpython3.8 \
	libusb-1.0 \
	libczmq4 \
	libelf1 \
	libsdl2-2.0-0 \
	libcapstone4 \
	libncurses6 \
	libglib2.0-0 \
	cmake \
	stlink-tools \
	gdb-multiarch \
	&& rm -rf /var/lib/apt/lists/*

# ARM GCC Compiler
RUN curl -sL "https://developer.arm.com/-/media/Files/downloads/gnu/14.2.rel1/binrel/arm-gnu-toolchain-14.2.rel1-x86_64-arm-none-eabi.tar.xz" | tar -xJf - -C /usr/local --strip-components=1

# OpenOCD (version 0.12.0-6)
RUN mkdir /opt/openocd && \
	curl -sL "https://github.com/xpack-dev-tools/openocd-xpack/releases/download/v0.12.0-6/xpack-openocd-0.12.0-6-linux-x64.tar.gz" | tar -xzf - -C /opt/openocd --strip-components=1 && \
	ln -s /opt/openocd/bin/openocd /usr/local/bin/openocd

# STM32CubeProgrammer (version 2.13.0)
ADD stm32cubeprogrammer /opt/stm32cubeprogrammer
RUN ln -s /opt/stm32cubeprogrammer/bin/STM32_Programmer_CLI /usr/local/bin/STM32_Programmer_CLI

# PyOCD
RUN pip install --break-system-packages pyocd==0.36.0

# clangd (version 17.0.3)
RUN mkdir /tmp/clangd && \
	curl -sL -o /tmp/clangd/clangd.zip "https://github.com/clangd/clangd/releases/download/20.1.0/clangd-linux-20.1.0.zip" && \
	unzip /tmp/clangd/clangd.zip -d /tmp/clangd && \
	cp -r /tmp/clangd/clangd_20.1.0/* /usr/local/ && \
	rm /tmp/clangd -rf

# Clangd default configuration
COPY --chown=vscode:vscode config.yaml /home/vscode/.config/clangd/config.yaml

# Orbuculum
COPY --from=orbuculum_build	/orbuculum /

# Pyocd packs
COPY --from=pyocd_pack_build --chown=vscode:vscode /root/.local/share/cmsis-pack-manager/ /home/vscode/.local/share/cmsis-pack-manager/
