FROM ghcr.io/zephyrproject-rtos/ci:v0.27.5

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive && \
	apt-get -y install curl \
	&& rm -rf /var/lib/apt/lists/*

# clangd (version 20.1.0)
RUN mkdir /tmp/clangd && \
	curl -sL -o /tmp/clangd/clangd.zip "https://github.com/clangd/clangd/releases/download/20.1.0/clangd-linux-20.1.0.zip" && \
	unzip /tmp/clangd/clangd.zip -d /tmp/clangd && \
	cp -r /tmp/clangd/clangd_20.1.0/* /usr/local/ && \
	rm /tmp/clangd -rf

# Clangd default configuration
COPY --chown=user:user config.yaml /home/user/.config/clangd/config.yaml

RUN chsh --shell /bin/bash user
