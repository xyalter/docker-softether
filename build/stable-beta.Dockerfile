FROM debian:stretch

RUN apt-get -qq update && DEBIAN_FRONTEND=noninteractive \
    apt-get -yqq install build-essential \
                         git \
                         curl

RUN apt-get -qq update && DEBIAN_FRONTEND=noninteractive \
    apt-get -yqq install cmake \
                         libncurses5-dev \
                         libreadline-dev \
                         libssl-dev \
                         zlib1g-dev

ENV BASE_URL='https://github.com/SoftEtherVPN'
ENV STABLE_GIT=${BASE_URL}/SoftEtherVPN_Stable.git

ARG VERSION='v4.28-9669-beta'

ENV BASE_DIR=/data/SoftEtherVPN
RUN mkdir -p "${BASE_DIR}"
WORKDIR ${BASE_DIR}

RUN apt-get -qq update && DEBIAN_FRONTEND=noninteractive \
    apt-get -yqq install git build-essential

RUN apt-get -qq update && DEBIAN_FRONTEND=noninteractive \
    apt-get -yqq install cmake \
                         libreadline-dev \
                         libssl-dev \
                         libncurses5-dev \
                         zlib1g-dev

RUN git clone ${STABLE_GIT} . && \
    git checkout tags/${VERSION}

RUN ./configure && \
    make && \
    make install && \
    make clean
