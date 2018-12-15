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
