FROM espressif/idf:v5.0.2

# Add non-root user
RUN useradd -s /bin/bash -m vscode

COPY 02-esp.sh /etc/profile.d/

USER vscode

# Trust ESP git folders
RUN git config --global --add safe.directory "*"

USER root