FROM debian:stretch as builder

RUN apt-get -qq update && DEBIAN_FRONTEND=noninteractive \
    apt-get -yqq install git cmake make gcc g++ \
                         libncurses5-dev \
                         libreadline-dev \
                         libssl-dev \
                         zlib1g-dev

ENV BASE_URL='https://github.com/SoftEtherVPN'
ENV STABLE_GIT=${BASE_URL}/SoftEtherVPN.git

ARG VERSION='v5.01.9666'

ENV BASE_DIR=/data/SoftEtherVPN
RUN mkdir -p "${BASE_DIR}"
WORKDIR ${BASE_DIR}

RUN git clone ${STABLE_GIT} . && \
    git checkout tags/${VERSION}

RUN git submodule init && \
    git submodule update && \
    ./configure && \
    make -C tmp && \
    make -C tmp install


FROM debian:stretch

RUN apt-get -qq update && DEBIAN_FRONTEND=noninteractive \
    apt-get -yqq install libreadline7 \
                         libssl1.1 \
                         libncurses5 \
                         zlib1g

ENV BIN_DIR=/usr/local/bin \
    LIBEXEC_DIR=/usr/local/libexec/softether \
    LIB_DIR=usr/local/lib \
    SYSTEMD_DIR=/lib/systemd/system

COPY --from=builder /usr/local/lib/libcedar.so \
                    /usr/local/lib/libmayaqua.so \
                    /usr/local/lib/

COPY --from=builder ${LIB_DIR}/libcpu_features.a ${LIB_DIR}/libcpu_features.a
ENV INCLUDE_DIR=/usr/local/include/cpu_features
COPY --from=builder ${INCLUDE_DIR}/cpuinfo_aarch64.h \
                    ${INCLUDE_DIR}/cpuinfo_arm.h \
                    ${INCLUDE_DIR}/cpuinfo_mips.h \
                    ${INCLUDE_DIR}/cpuinfo_ppc.h \
                    ${INCLUDE_DIR}/cpuinfo_x86.h \
                    ${INCLUDE_DIR}/cpu_features_macros.h \
                    ${INCLUDE_DIR}/

COPY --from=builder ${BIN_DIR}/list_cpu_features ${BIN_DIR}
ENV CMAKE_DIR=/usr/local/lib/cmake/CpuFeatures
COPY --from=builder ${CMAKE_DIR}/CpuFeaturesTargets.cmake \
                    ${CMAKE_DIR}/CpuFeaturesTargets-relwithdebinfo.cmake \
                    ${CMAKE_DIR}/CpuFeaturesConfig.cmake \
                    ${CMAKE_DIR}/CpuFeaturesConfigVersion.cmake \
                    ${CMAKE_DIR}/

COPY --from=builder $LIBEXEC_DIR/vpnserver/hamcore.se2 \
                    $LIBEXEC_DIR/vpnserver/vpnserver \
                    $LIBEXEC_DIR/vpnserver/
COPY --from=builder $BIN_DIR/vpnserver $BIN_DIR/
COPY --from=builder $SYSTEMD_DIR/softether-vpnserver.service $SYSTEMD_DIR/

COPY --from=builder $LIBEXEC_DIR/vpnbridge/hamcore.se2 \
                    $LIBEXEC_DIR/vpnbridge/vpnbridge \
                    $LIBEXEC_DIR/vpnbridge/
COPY --from=builder $BIN_DIR/vpnbridge $BIN_DIR/
COPY --from=builder $SYSTEMD_DIR/softether-vpnbridge.service $SYSTEMD_DIR/

COPY --from=builder $LIBEXEC_DIR/vpnclient/hamcore.se2 \
                    $LIBEXEC_DIR/vpnclient/vpnclient \
                    $LIBEXEC_DIR/vpnclient/
COPY --from=builder $LIBEXEC_DIR/vpnclient/* $LIBEXEC_DIR/vpnclient/
COPY --from=builder $BIN_DIR/vpnclient $BIN_DIR/
COPY --from=builder $SYSTEMD_DIR/softether-vpnclient.service $SYSTEMD_DIR/

COPY --from=builder $LIBEXEC_DIR/vpnclient/vpnclient $LIBEXEC_DIR/vpnclient/
COPY --from=builder $LIBEXEC_DIR/vpncmd/* $LIBEXEC_DIR/vpncmd/
COPY --from=builder $BIN_DIR/vpncmd $BIN_DIR/

CMD ["bash"]
