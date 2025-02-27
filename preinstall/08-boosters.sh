#!/bin/bash

echo "DOWNLOAD COMMON LIBRARY BOOSTER #################################################################################" \
    && allpath=/var/home-cnf-common-library-all.sh \
    && wget https://raw.githubusercontent.com/shkodina/home-cnf-common-library/refs/heads/main/all.sh -O $allpath \
    && chmod +r $allpath \
    && for u in sshuser piper blobby bob ansible; do \
        echo "source $allpath" >> /home/$u/.bashrc ; \
        done \
    && echo "source $allpath" >> ~/.bashrc ; 
