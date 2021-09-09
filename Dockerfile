FROM alpine:3.14

LABEL org.opencontainers.image.authors="Óscar de Arriba <odarriba@hey.com>"

ARG storj_version=1.37.2
ARG arch=amd64

WORKDIR /tmp

ADD create_identity /usr/local/bin/create_identity

# Install multinode & identity binaries
RUN apk add --update --no-cache unzip curl \
  && curl -LO https://github.com/storj/storj/releases/download/v${storj_version}/multinode_linux_${arch}.zip \
  && curl -LO https://github.com/storj/storj/releases/download/v${storj_version}/identity_linux_${arch}.zip \
  && unzip multinode_linux_${arch}.zip \
  && unzip identity_linux_${arch}.zip \
  && mv multinode /usr/local/bin/ \
  && mv identity /usr/local/bin/ \
  && chmod +x /usr/local/bin/multinode \
  && chmod +x /usr/local/bin/identity \
  && chmod +x /usr/local/bin/create_identity \
  && apk del curl unzip

# Prepare mountpoints
RUN mkdir -p /root/.local/share/storj/multinode \
  && mkdir -p /root/.local/share/storj/identity

VOLUME /root/.local/share/storj/multinode
VOLUME /root/.local/share/storj/identity

EXPOSE 15002

ENTRYPOINT ["/usr/local/bin/multinode"]
CMD ["run"]
