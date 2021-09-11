FROM alpine:3.14

LABEL org.opencontainers.image.authors="Óscar de Arriba <odarriba@hey.com>"

ARG STORJ_VERSION=1.37.2
ARG ARCH=amd64

WORKDIR /tmp

ADD create_identity /usr/local/bin/create_identity
ADD install.sh /tmp/install.sh

# Install multinode & identity binaries
RUN sh /tmp/install.sh \
  && chmod +x /usr/local/bin/create_identity

# Prepare mountpoints
RUN mkdir -p /root/.local/share/storj/multinode \
  && mkdir -p /root/.local/share/storj/identity

VOLUME /root/.local/share/storj/multinode
VOLUME /root/.local/share/storj/identity

EXPOSE 15002

ENTRYPOINT ["/usr/local/bin/multinode"]
CMD ["run"]
