FROM debian:stretch

RUN apt-get -qq update && DEBIAN_FRONTEND=noninteractive \
    apt-get -yqq install libncurses5 \
                         libreadline7 \
                         libssl1.1 \
                         zlib1g
