ARG RUST_VERSION=1.86.0
ARG DEBIAN_VERSION=bullseye

FROM rust:${RUST_VERSION}-${DEBIAN_VERSION}
ENV PKG_CONFIG_SYSROOT_DIR=/
RUN curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o /tmp/awscliv2.zip && \
	unzip /tmp/awscliv2.zip -d /tmp && \
	rm /tmp/awscliv2.zip && \
	/tmp/aws/install && \
	rm -rf /tmp/aws
RUN rustup toolchain install nightly
RUN rustup target add aarch64-unknown-linux-gnu
RUN rustup target add --toolchain nightly aarch64-unknown-linux-gnu
RUN rustup component add clippy
RUN curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash
RUN cargo install --locked cargo-audit cargo-outdated cargo-nextest cargo-tarpaulin cargo-sonar cargo-export clippy-sarif
RUN dpkg --add-architecture arm64
RUN echo 'deb [trusted=yes] https://deepviewml.com/apt stable main' > /etc/apt/sources.list.d/deepviewml.list
RUN apt-get update && apt-get -y install \
	cmake \
	gcc-aarch64-linux-gnu \
	g++-aarch64-linux-gnu \
	python3 \
	python3-setuptools \
	python3-wheel \
	python3-pip \
	nasm \
	patchelf \
	libsystemd-dev libsystemd-dev:arm64 \
	libsqlite3-dev libsqlite3-dev:arm64 \
	liblzma-dev liblzma-dev:arm64 \
	libvideostream-dev libvideostream:arm64 \
	libvaal-dev libvaal:arm64
