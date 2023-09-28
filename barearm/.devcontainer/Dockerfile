FROM ubuntu:22.04 AS orbuculum_build

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive && \
	apt-get -y install git build-essential curl libusb-1.0-0-dev libczmq-dev libncurses-dev

RUN git clone --depth 1 --branch V2.0.0 https://github.com/orbcode/orbuculum.git orbuculum_build && \
	cd orbuculum_build && make && \
	make DESTDIR=/orbuculum install

FROM mcr.microsoft.com/devcontainers/base:1.0.8-ubuntu-22.04

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive && \
	apt-get -y install make bear picocom xz-utils python3-pip telnet libncurses5 libusb-1.0 libczmq4 libncurses6 libglib2.0-0 cmake

# ARM GCC Compiler
RUN curl -sL "https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-rm/10.3-2021.10/gcc-arm-none-eabi-10.3-2021.10-x86_64-linux.tar.bz2" | tar -xjf - -C /usr/local --strip-components=1

# OpenOCD (version 0.12.0-1)
RUN mkdir /opt/openocd && \
	curl -sL "https://github.com/xpack-dev-tools/openocd-xpack/releases/download/v0.12.0-1/xpack-openocd-0.12.0-1-linux-x64.tar.gz" | tar -xzf - -C /opt/openocd --strip-components=1 && \
	ln -s /opt/openocd/bin/openocd /usr/local/bin/openocd

# STM32CubeProgrammer (version 2.13.0)
ADD stm32cubeprogrammer /opt/stm32cubeprogrammer
RUN ln -s /opt/stm32cubeprogrammer/bin/STM32_Programmer_CLI /usr/local/bin/STM32_Programmer_CLI

# Texane st-link (version 1.7.0 in repository)
RUN export DEBIAN_FRONTEND=noninteractive && \
	apt-get -y install stlink-tools

# PyOCD
RUN pip install pyocd==0.35.1

USER vscode

RUN pyocd pack install stm32 nrf51 && \
	cd ~/.local/share/cmsis-pack-manager/ && \
	for file in $(find . -iname "*.pack"); do zipinfo -1 $file | sed '/^.*\(flm\|pdsc\|svd\|dbgconf\|sdf\)/Id' | xargs zip -d $file; done

USER root

# clangd (version 16.0.2)
RUN mkdir /tmp/clangd && \
	curl -sL -o /tmp/clangd/clangd.zip "https://github.com/clangd/clangd/releases/download/16.0.2/clangd-linux-16.0.2.zip" && \
	unzip /tmp/clangd/clangd.zip -d /tmp/clangd && \
	cp -r /tmp/clangd/clangd_16.0.2/* /usr/local/ && \
	rm /tmp/clangd -rf

# Orbuculum
COPY --from=orbuculum_build	/orbuculum /
