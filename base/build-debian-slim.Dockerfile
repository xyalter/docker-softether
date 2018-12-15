FROM debian:stretch

RUN apt-get -qq update && DEBIAN_FRONTEND=noninteractive \
    apt-get -yqq install git cmake make gcc g++ \
                         libncurses5-dev \
                         libreadline-dev \
                         libssl-dev \
                         zlib1g-dev
