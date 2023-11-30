ARG REGISTRY=gcr.io/hdl-containers/debian/bookworm

FROM $REGISTRY/pkg/iverilog as pkg-iverilog
FROM $REGISTRY/pkg/openfpgaloader as pkg-openfpgaloader

# WORKAROUND: this is required because 'COPY --from' does not support ARGs
FROM $REGISTRY/impl

# Dependencies
RUN apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
	libftdi1-2 \
	libhidapi-hidraw0 \
	usbutils \
	gcc-riscv64-unknown-elf \
	gdb-multiarch \
	&& apt-get autoclean && apt-get clean && apt-get -y autoremove \
	&& rm -rf /var/lib/apt/lists/*

# OpenOCD (version 0.12.0-1)
RUN mkdir /opt/openocd && \
	curl -sL "https://github.com/xpack-dev-tools/openocd-xpack/releases/download/v0.12.0-1/xpack-openocd-0.12.0-1-linux-x64.tar.gz" | tar -xzf - -C /opt/openocd --strip-components=1 && \
	ln -s /opt/openocd/bin/openocd /usr/local/bin/openocd

COPY --from=pkg-iverilog /iverilog /
COPY --from=pkg-openfpgaloader /openfpgaloader /

