FROM ubuntu:22.04 AS orbuculum_build

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive && \
	apt-get -y install git build-essential curl libusb-1.0-0-dev libczmq-dev libncurses-dev meson libsdl2-dev

RUN git clone --depth 1 --branch V2.1.0 https://github.com/orbcode/orbuculum.git orbuculum_build && \
	cd orbuculum_build && meson setup --prefix=/usr build && \
	meson compile -C build && \
	DESTDIR=/orbuculum meson install -C build

FROM mcr.microsoft.com/devcontainers/base:1.0.8-ubuntu-22.04

RUN echo "deb https://ppa.launchpadcontent.net/deadsnakes/ppa/ubuntu jammy main" >> /etc/apt/sources.list && \
	apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F23C5A6CF475977595C89F51BA6932366A755776

# Texane st-link (version 1.7.0 in repository)
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive && \
	apt-get -y install \
	make \
	bear \
	picocom \
	xz-utils \
	python3-pip \
	telnet \
	libncursesw5 \
	python3.8 \
	libusb-1.0 \
	libczmq4 \
	libncurses6 \
	libncurses5 \
	libglib2.0-0 \
	cmake \
	stlink-tools \
	&& rm -rf /var/lib/apt/lists/*

# ARM GCC Compiler
RUN curl -sL "https://launchpad.net/gcc-arm-embedded/4.7/4.7-2012-q4-major/+download/gcc-arm-none-eabi-4_7-2012q4-20121208-linux.tar.bz2" | tar -xjf - -C /usr/local --strip-components=1

# OpenOCD (version 0.12.0-1)
RUN mkdir /opt/openocd && \
	curl -sL "https://github.com/xpack-dev-tools/openocd-xpack/releases/download/v0.12.0-1/xpack-openocd-0.12.0-1-linux-x64.tar.gz" | tar -xzf - -C /opt/openocd --strip-components=1 && \
	ln -s /opt/openocd/bin/openocd /usr/local/bin/openocd

# STM32CubeProgrammer (version 2.13.0)
ADD stm32cubeprogrammer /opt/stm32cubeprogrammer
RUN ln -s /opt/stm32cubeprogrammer/bin/STM32_Programmer_CLI /usr/local/bin/STM32_Programmer_CLI

# PyOCD
RUN pip install pyocd==0.36.0

USER vscode

RUN pyocd pack install stm32 nrf51 && \
	cd ~/.local/share/cmsis-pack-manager/ && \
	for file in $(find . -iname "*.pack"); do zipinfo -1 $file | sed '/^.*\(flm\|pdsc\|svd\|dbgconf\|sdf\)/Id' | xargs zip -d $file; done

USER root

# clangd (version 17.0.3)
RUN mkdir /tmp/clangd && \
	curl -sL -o /tmp/clangd/clangd.zip "https://github.com/clangd/clangd/releases/download/17.0.3/clangd-linux-17.0.3.zip" && \
	unzip /tmp/clangd/clangd.zip -d /tmp/clangd && \
	cp -r /tmp/clangd/clangd_17.0.3/* /usr/local/ && \
	rm /tmp/clangd -rf

# Clangd default configuration
COPY --chown=vscode:vscode config.yaml /home/vscode/.config/clangd/config.yaml

# Orbuculum
COPY --from=orbuculum_build	/orbuculum /

# Enable 32 bit architecture
RUN dpkg --add-architecture i386 && \
	apt-get update && export DEBIAN_FRONTEND=noninteractive && \
	apt-get -y install libc6:i386 libncurses5:i386 libstdc++6:i386 && \
	rm -rf /var/lib/apt/lists/*