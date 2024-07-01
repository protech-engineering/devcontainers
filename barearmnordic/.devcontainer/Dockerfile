FROM ghcr.io/protech-engineering/devcontainers:barearm-9_2019_q4_major-A

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive && \
	apt-get -y install gcc srecord python3.6 bluez && \
	rm -rf /var/lib/apt/lists/*

# Install specific protobuf version (for nordic sdk --> protobuf <= 3.19)
RUN pip install protobuf==3.19.0

# Nordic sdk dependencies
RUN pip install nrfutil==6.1.6

# Debug utilities
RUN pip install ble-serial

# nrfjprog
RUN curl https://nsscprodmedia.blob.core.windows.net/prod/software-and-other-downloads/desktop-software/nrf-command-line-tools/sw/versions-10-x-x/10-24-2/nrf-command-line-tools_10.24.2_amd64.deb -o nrftools.deb && \
	apt-get update && export DEBIAN_FRONTEND=noninteractive && \
	apt-get -y install ./nrftools.deb && \
	cp /usr/bin/udevadm /usr/bin/udevadm.old && \
	echo '#!/bin/bash\necho not running udevadm "$@"' > /usr/bin/udevadm && \
	chmod +x /usr/bin/udevadm && \
	apt-get -y install /opt/nrf-command-line-tools/share/JLink_Linux_V794e_x86_64.deb --fix-broken && \
	mv /usr/bin/udevadm.old /usr/bin/udevadm && \
	rm -rf /var/lib/apt/lists/* && \
	rm nrftools.deb
