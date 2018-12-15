FROM debian:stretch as builder

RUN apt-get -qq update && DEBIAN_FRONTEND=noninteractive \
    apt-get -yqq install git cmake make gcc g++ \ 
                         libncurses5-dev \
                         libreadline-dev \
                         libssl-dev \
                         zlib1g-dev

ENV BASE_URL='https://github.com/SoftEtherVPN'
ENV STABLE_GIT=${BASE_URL}/SoftEtherVPN_Stable.git

ARG VERSION='v4.25-9656-rtm'

ENV BASE_DIR=/data/SoftEtherVPN
RUN mkdir -p "${BASE_DIR}"
WORKDIR ${BASE_DIR}

RUN git clone ${STABLE_GIT} . && \
    git checkout tags/${VERSION}

RUN ./configure && \
    make && \
    make install && \
    make clean


FROM debian:stretch

RUN apt-get -qq update && DEBIAN_FRONTEND=noninteractive \
    apt-get -yqq install libreadline7 \
                         libssl1.1 \
                         libncurses5 \
                         zlib1g

ENV INSTALL_BINDIR=/usr/bin/ \
    INSTALL_VPNSERVER_DIR=/usr/vpnserver/ \
    INSTALL_VPNBRIDGE_DIR=/usr/vpnbridge/ \
    INSTALL_VPNCLIENT_DIR=/usr/vpnclient/ \
    INSTALL_VPNCMD_DIR=/usr/vpncmd/

RUN mkdir -p "$INSTALL_BINDIR" && \
    mkdir -p "$INSTALL_VPNSERVER_DIR" && \
    mkdir -p "$INSTALL_VPNBRIDGE_DIR" && \
    mkdir -p "$INSTALL_VPNCLIENT_DIR" && \
    mkdir -p "$INSTALL_VPNCMD_DIR"

COPY --from=builder "$INSTALL_BINDIR"/vpnserver "$INSTALL_BINDIR"
COPY --from=builder "$INSTALL_BINDIR"/vpnbridge "$INSTALL_BINDIR"
COPY --from=builder "$INSTALL_BINDIR"/vpnclient "$INSTALL_BINDIR"
COPY --from=builder "$INSTALL_BINDIR"/vpncmd "$INSTALL_BINDIR"

COPY --from=builder "$INSTALL_VPNSERVER_DIR" "$INSTALL_VPNSERVER_DIR"
COPY --from=builder "$INSTALL_VPNBRIDGE_DIR" "$INSTALL_VPNBRIDGE_DIR"
COPY --from=builder "$INSTALL_VPNCLIENT_DIR" "$INSTALL_VPNCLIENT_DIR"
COPY --from=builder "$INSTALL_VPNCMD_DIR" "$INSTALL_VPNCMD_DIR"

CMD ["bash"]
