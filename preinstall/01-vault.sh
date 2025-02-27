#!/bin/bash

echo "vault install #################################################################################" \
    && wget "https://www.dropbox.com/scl/fi/qwauqe70w4jh4op0ldws6/vault_1.13.2-yckms_linux_amd64.zip?rlkey=0rv4lqk67qt0wo1heeafeqgwk&st=abx29yi1&dl=0" -O /tmp/vault.zip \
    && unzip /tmp/vault.zip \
    && rm -f /tmp/vault.zip \
    && chmod a+x vault \
    && mv vault /usr/bin/
