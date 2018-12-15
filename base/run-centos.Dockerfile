FROM centos:7

RUN yum -y -q update && \
    yum -y -q --setopt=tsflags=nodocs \
    install ncurses \
            openssl \
            readline \
            zlib && \
    yum clean all
