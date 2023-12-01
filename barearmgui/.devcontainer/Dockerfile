FROM ghcr.io/protech-engineering/devcontainers:barearm-11.3.Rel1-C

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive && \
	apt-get -y install \
	gcc \
	libsdl2-image-dev \
	mingw-w64 \
	&& rm -rf /var/lib/apt/lists/*

# Download minGW libraries
RUN curl -sL "https://www.libsdl.org/release/SDL2-devel-2.0.20-mingw.tar.gz" | tar -xzf - && \
	cd SDL2-2.0.20 && \
	make cross CROSS_PATH=/usr && \
	cd .. && rm -rf SDL2-2.0.20
RUN curl -sL "https://www.libsdl.org/projects/SDL_image/release/SDL2_image-devel-2.0.5-mingw.tar.gz" | tar -xzf - && \
	cd SDL2_image-2.0.5 && \
	make cross CROSS_PATH=/usr && \
	cd .. && rm -rf SDL2_image-devel-2.0.5-mingw.tar.gz SDL2_image-2.0.5

# Installing emscripten
RUN curl -sL "https://github.com/emscripten-core/emsdk/archive/refs/tags/3.1.5.tar.gz" | tar -xzf - -C /opt && \
	sh /opt/emsdk-3.1.5/emsdk install 3.1.5 && \
	sh /opt/emsdk-3.1.5/emsdk activate 3.1.5
