FROM mcr.microsoft.com/devcontainers/base:ubuntu24.04

# Deps
RUN apt-get update && apt-get install -y gcc gcc-multilib wget ca-certificates qemu-system-arm git \
    libxcb-render-util0 libxcb-shape0 libxcb-icccm4  libxcb-keysyms1 libxcb-image0 libxkbcommon-x11-0 libsm6 libice6 udev \
    && rm -rf /var/lib/apt/lists/*

# nrfutil 
RUN HOME=/opt wget https://files.nordicsemi.com/artifactory/swtools/external/nrfutil/executables/x86_64-unknown-linux-gnu/nrfutil -q -O /usr/local/bin/nrfutil  \
    && chmod +x /usr/local/bin/nrfutil

# clangd (version 22.1.0)
RUN apt-get update && apt-get install -y --no-install-recommends unzip && rm -rf /var/lib/apt/lists/* && \
	mkdir /tmp/clangd && \
	wget -qO /tmp/clangd/clangd.zip "https://github.com/clangd/clangd/releases/download/22.1.0/clangd-linux-22.1.0.zip" && \
	unzip /tmp/clangd/clangd.zip -d /tmp/clangd && \
	cp -r /tmp/clangd/clangd_22.1.0/* /usr/local/ && \
	rm -rf /tmp/clangd

# JLink
RUN wget --post-data="accept_license_agreement=accepted&submit=Download+software" -O /tmp/jlink.deb https://www.segger.com/downloads/jlink/JLink_Linux_V916a_x86_64.deb && \
 	/lib/systemd/systemd-udevd --daemon && \
	dpkg -i /tmp/jlink.deb || true && \
	rm /tmp/jlink.deb

# Clangd default configuration
COPY --chown=vscode:vscode config.yaml /home/vscode/.config/clangd/config.yaml

USER vscode

ARG VERSION=911f4c5c26 # ncs v3.3.0
RUN nrfutil install toolchain-manager=0.15.0 \
    && nrfutil toolchain-manager install --toolchain-bundle-id $VERSION \
    && nrfutil toolchain-manager env --as-script >> /home/vscode/.bashrc \
    && rm -rf /home/vscode/ncs/downloads