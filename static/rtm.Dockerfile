FROM xxy1991/debian:build as builder

ENV BASE_URL='https://github.com/SoftEtherVPN'
ENV STABLE_URL=${BASE_URL}/'SoftEtherVPN_Stable/releases/download'

ARG VERSION='v4.25-9656-rtm'
ARG FEATURE='vpnserver'
ARG DATE='2018.01.15'
ARG OS='linux'
ARG ARCH='x64-64bit'

ENV FILE='softether-'${FEATURE}'-'${VERSION}'-'${DATE}'-'${OS}'-'${ARCH}'.tar.gz'

ENV URL=${STABLE_URL}/${VERSION}/${FILE}

ENV BASE_DIR=/data/SoftEtherVPN
RUN mkdir -p "${BASE_DIR}"
WORKDIR ${BASE_DIR}

# RUN apt-get -qq update && DEBIAN_FRONTEND=noninteractive \
#     apt-get -yqq install curl build-essential

RUN curl -SL "${URL}" \
    | tar -xzC . && \
    cd $FEATURE && \
    make i_read_and_agree_the_license_agreement

FROM debian:stretch

ARG FEATURE='vpnserver'

ENV BASE_DIR=/usr/local/$FEATURE
RUN mkdir -p "${BASE_DIR}"
WORKDIR ${BASE_DIR}

COPY --from=builder /data/SoftEtherVPN/* .
RUN chmod 600 * && \
    chmod 700 $FEATURE && \
    chmod 700 vpncmd

CMD ["bash"]
