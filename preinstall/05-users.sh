#!/bin/bash

echo "INSTALL SSH USER ####################################################################" \
    && echo "export SSH_USER_NAME=sshuser" >> ~/.bashrc \
    && echo "export SSH_USER_PASS=password" >> ~/.bashrc \
    && source ~/.bashrc \
    && ( useradd -m -s /bin/bash $SSH_USER_NAME || true ) \
    && echo -e "${SSH_USER_PASS}\n${SSH_USER_PASS}" | passwd $SSH_USER_NAME \
    && ( useradd -m -s /bin/bash piper || true ) \
    && echo -e "piper\npiper" | passwd piper \
    && ( useradd -m -s /bin/bash ansible || true ) \
    && echo -e "ansible\nansible" | passwd ansible \
    && ( useradd -m -s /bin/bash bob || true ) \
    && echo -e "bob\nbob" | passwd bob \

