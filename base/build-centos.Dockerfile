FROM centos:7

RUN yum -y -q update && \
    yum -y -q --setopt=tsflags=nodocs \
    groupinstall 'Development Tools' && \
    yum -y -q --setopt=tsflags=nodocs \
    install git \
            curl && \
    yum clean all

# RUN yum -y -q update && \
#     yum -y -q --setopt=tsflags=nodocs \
#     install epel-release && \
#     yum clean all

RUN yum -y -q update && \
    yum -y -q --setopt=tsflags=nodocs \
    install cmake3 \
            ncurses-devel \
            openssl-devel \
            readline-devel \
            zlib-devel && \
    ln -s /usr/bin/cmake3 /usr/bin/cmake && \
    yum clean all
