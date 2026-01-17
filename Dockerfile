
FROM debian:bookworm-slim
ARG MONO_VERSION=mono-6.14.1

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		build-essential autoconf automake libtool pkg-config cmake git wget ca-certificates \
		gettext libglib2.0-dev libssl-dev libx11-dev libxrandr-dev libxfixes-dev libxext-dev \
		libasound2-dev libgcrypt20-dev libpng-dev libjpeg-dev libtiff-dev libpango1.0-dev \
		libfreetype6-dev libffi-dev zlib1g-dev curl && \
	rm -rf /var/lib/apt/lists/*

WORKDIR /tmp

RUN set -eux; \
	git clone --depth 1 --branch "${MONO_VERSION}" --recursive https://gitlab.winehq.org/mono/mono.git /mono-src; \
	cd /mono-src; \
	./autogen.sh --prefix=/opt/mono; \
	make -j"$(nproc)"; \
	make install; \
	rm -rf /mono-src
