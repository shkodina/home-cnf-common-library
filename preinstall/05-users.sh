#!/bin/bash

echo "INSTALL USERS ####################################################################" \
    && for u in sshuser piper blobby bob ansible; \
        do \
            useradd -m -s /bin/bash $u || true; \
            echo -e "$u\n$u" | passwd $u; \
        done


