#!/bin/bash

echo "apt install #################################################################################" \
    && apt update \
    && apt upgrade -y \
    && apt install -y \
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

echo "install yq  ##################################################################################" \
    && wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 \
    && chmod a+x /usr/local/bin/yq
