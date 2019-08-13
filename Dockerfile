# ===== START FIRST STAGE ======
FROM phusion/baseimage:0.11 as builder
LABEL maintainer "support@polkasource.com"
LABEL description="Large image for building the Substrate binary."

ARG PROFILE=release
ARG REPOSITORY=akropolisio-akropolis-polkadot
WORKDIR /rustbuilder
COPY . /rustbuilder

# PREPARE OPERATING SYSTEM & BUILDING ENVIRONMENT
RUN apt-get update && \
	apt-get upgrade -y && \
	apt-get install -y cmake pkg-config libssl-dev git clang libclang-dev 
	
# CHECKOUT GIT SUBMODULES
RUN git submodule update --init --recursive
	
# UPDATE RUST DEPENDENCIES
ENV RUSTUP_HOME "/rustbuilder/.rustup"
ENV CARGO_HOME "/rustbuilder/.cargo"
RUN curl -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH "$PATH:/rustbuilder/.cargo/bin"
RUN rustup update nightly
RUN RUSTUP_TOOLCHAIN=stable cargo install --git https://github.com/alexcrichton/wasm-gc

# BUILD RUNTIME AND BINARY
RUN rustup target add wasm32-unknown-unknown --toolchain nightly
RUN cd /rustbuilder/$REPOSITORY/runtime/wasm && ./build.sh
RUN cd /rustbuilder/$REPOSITORY && RUSTUP_TOOLCHAIN=stable cargo build --$PROFILE
# ===== END FIRST STAGE ======

# ===== START SECOND STAGE ======
FROM phusion/baseimage:0.11
LABEL maintainer "support@polkasource.com"
LABEL description="Small image with the Substrate binary."
ARG PROFILE=release
ARG REPOSITORY=akropolisio-akropolis-polkadot
COPY --from=builder /rustbuilder/$REPOSITORY/target/$PROFILE/substrate /usr/local/bin

COPY --from=builder /rustbuilder/$REPOSITORY/target/$PROFILE/akropolis /usr/local/bin
COPY --from=builder /rustbuilder/$REPOSITORY/spec.json /usr/local/bin/spec.json

# REMOVE & CLEANUP
RUN mv /usr/share/ca* /tmp && \
	rm -rf /usr/share/*  && \
	mv /tmp/ca-certificates /usr/share/ && \
	rm -rf /usr/lib/python* && \
	mkdir -p /root/.local/share/akropolis && \
	ln -s /root/.local/share/akropolis /data
RUN	rm -rf /usr/bin /usr/sbin

# FINAL PREPARATIONS
EXPOSE 30333 9933 9944
VOLUME ["/data"]
#CMD ["/usr/local/bin/akropolis"]
WORKDIR /usr/local/bin
ENTRYPOINT ["akropolis"]
CMD ["--chain=akropolis"]
# ===== END SECOND STAGE ======
