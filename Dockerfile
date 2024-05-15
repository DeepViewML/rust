ARG RUST_VERSION=1.78.0
ARG DEBIAN_VERSION=bullseye

FROM rust:${RUST_VERSION}-${DEBIAN_VERSION}
ENV PKG_CONFIG_SYSROOT_DIR=/
RUN rustup target add aarch64-unknown-linux-gnu
RUN rustup component add clippy
RUN curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash
RUN cargo install cargo-audit cargo-outdated cargo-nextest cargo-tarpaulin cargo-sonar
RUN dpkg --add-architecture arm64
RUN curl https://deepviewml.com/apt/key.pub | gpg --batch --yes --dearmor -o /usr/share/keyrings/deepviewml.gpg
RUN echo 'deb [signed-by=/usr/share/keyrings/deepviewml.gpg] https://deepviewml.com/apt stable main' > /etc/apt/sources.list.d/deepviewml.list
RUN apt-get update && apt-get -y install \
	cmake \
	gcc-aarch64-linux-gnu \
	g++-aarch64-linux-gnu \
	nasm \
	libvideostream libvideostream:arm64 \
	libvaal libvaal:arm64
