#!/bin/bash

echo "apt install #################################################################################" \
    && apt update \
    && apt upgrade -y \
    && DEBIAN_FRONTEND=noninteractive apt install -y \
        bash-completion \
        curl \
        jq \
        wget \
        unzip \
        uuid-runtime \
        gettext-base \
        expect-dev \
        vim \
        git \
        netcat-openbsd \
    && rm -rf /var/lib/apt/lists/* \
    && rm -f /var/cache/apt/archives/*.deb 

echo "Set Time-Zone #################################################################################" \
    && timedatectl set-timezone Europe/Moscow

echo "install yq  ##################################################################################" \
    && wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 \
    && chmod a+x /usr/local/bin/yq
