FROM espressif/idf:v5.0.2

# clangd (version 16.0.2)
RUN mkdir /tmp/clangd && \
	curl -sL -o /tmp/clangd/clangd.zip "https://github.com/clangd/clangd/releases/download/16.0.2/clangd-linux-16.0.2.zip" && \
	unzip /tmp/clangd/clangd.zip -d /tmp/clangd && \
	cp -r /tmp/clangd/clangd_16.0.2/* /usr/local/

# Add non-root user
RUN useradd -s /bin/bash -m vscode

# Clangd default configuration
COPY config.yaml /home/vscode/.config/clangd/config.yaml

COPY 02-esp.sh /etc/profile.d/

USER vscode

# Trust ESP git folders
RUN git config --global --add safe.directory "*"

USER root