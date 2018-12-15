FROM xxy1991/softether:stable-beta as builder

FROM debian:stretch

RUN apt-get -qq update && DEBIAN_FRONTEND=noninteractive \
    apt-get -yqq install libreadline7 \
                         libssl1.1 \
                         libncurses5 \
                         zlib1g

ENV INSTALL_BINDIR=/usr/bin/ \
    INSTALL_VPNBRIDGE_DIR=/usr/vpnbridge/ \
    INSTALL_VPNCMD_DIR=/usr/vpncmd/

RUN mkdir -p "$INSTALL_BINDIR" && \
    mkdir -p "$INSTALL_VPNBRIDGE_DIR" && \
    mkdir -p "$INSTALL_VPNCMD_DIR"

COPY --from=builder "$INSTALL_BINDIR"/vpnbridge "$INSTALL_BINDIR"
COPY --from=builder "$INSTALL_BINDIR"/vpncmd "$INSTALL_BINDIR"

COPY --from=builder "$INSTALL_VPNBRIDGE_DIR" "$INSTALL_VPNBRIDGE_DIR"
COPY --from=builder "$INSTALL_VPNCMD_DIR" "$INSTALL_VPNCMD_DIR"

CMD ["bash"]
