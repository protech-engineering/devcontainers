FROM espressif/idf:v5.4.2

ENV IDF_GIT_SAFE_DIR="*"

# clangd (version 20.1.0)
RUN mkdir /tmp/clangd && \
	curl -sL -o /tmp/clangd/clangd.zip "https://github.com/clangd/clangd/releases/download/20.1.0/clangd-linux-20.1.0.zip" && \
	unzip /tmp/clangd/clangd.zip -d /tmp/clangd && \
	cp -r /tmp/clangd/clangd_20.1.0/* /usr/local/ && \
	rm -rf /tmp/clangd

COPY 02-esp.sh /etc/profile.d/

# Clangd default configuration
COPY --chown=ubuntu:ubuntu config.yaml /home/ubuntu/.config/clangd/config.yaml
