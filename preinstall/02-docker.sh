#!/bin/bash

echo "install docker  ##############################################################################" \
    && curl -fsSL https://get.docker.com | bash - \
    && rm -rf /var/lib/apt/lists/* \
    && rm -f /var/cache/apt/archives/*.deb

