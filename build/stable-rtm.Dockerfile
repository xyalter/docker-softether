FROM debian:stretch

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
