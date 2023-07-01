FROM ghcr.io/zephyrproject-rtos/ci:v0.26.1

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive && \
	apt-get -y install curl

# clangd (version 16.0.2)
RUN mkdir /tmp/clangd && \
	curl -sL -o /tmp/clangd/clangd.zip "https://github.com/clangd/clangd/releases/download/16.0.2/clangd-linux-16.0.2.zip" && \
	unzip /tmp/clangd/clangd.zip -d /tmp/clangd && \
	cp -r /tmp/clangd/clangd_16.0.2/* /usr/local/

RUN chsh --shell /bin/bash user
