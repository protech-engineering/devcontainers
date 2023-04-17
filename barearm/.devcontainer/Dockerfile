FROM ubuntu:22.04 AS orbuculum_build

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive && \
	apt-get -y install git build-essential curl libusb-1.0-0-dev libczmq-dev libncurses-dev

RUN git clone --depth 1 --branch V2.0.0 https://github.com/orbcode/orbuculum.git orbuculum_build && \
	cd orbuculum_build && make && \
	make DESTDIR=/orbuculum install

FROM mcr.microsoft.com/devcontainers/base:1.0.8-ubuntu-22.04

RUN echo "deb https://ppa.launchpadcontent.net/deadsnakes/ppa/ubuntu jammy main" >> /etc/apt/sources.list && \
	apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F23C5A6CF475977595C89F51BA6932366A755776

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive && \
	apt-get -y install make bear picocom xz-utils python3-pip telnet libncursesw5 python3.8 libusb-1.0 libczmq4 libncurses6 libglib2.0-0 cmake

# ARM GCC Compiler
RUN curl -sL "https://developer.arm.com/-/media/Files/downloads/gnu/12.2.rel1/binrel/arm-gnu-toolchain-12.2.rel1-x86_64-arm-none-eabi.tar.xz" | tar -xJf - -C /usr/local --strip-components=1

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
RUN pip install pyocd==0.34.3

# Orbuculum
COPY --from=orbuculum_build	/orbuculum /

# Test the container
ADD test /opt/test
ADD test/assert.sh /usr/local/bin/
RUN /opt/test/barearm.sh
