#!/bin/bash

echo "INSTALL NET UTILS ####################################################################" \
    && apt update \
    && apt upgrade -y \
    && apt install -y \
        dnsutils \
        net-tools \
        iputils-ping \
        htop \
        iotop\
        openssh-server \
        fzf \
        s3cmd \
        telnet \
    && rm -rf /var/lib/apt/lists/* \
    && rm -f /var/cache/apt/archives/*.deb
