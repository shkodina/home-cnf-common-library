#!/bin/bash

echo "install python  ##############################################################################" \
    && apt update \
    && apt upgrade -y \
    && apt install -y \
        python-is-python3 \
        python3-pip \
        python3-yaml \
        python3-requests \
        python3-venv \
        pipx \
    && rm -rf /var/lib/apt/lists/* \
    && rm -f /var/cache/apt/archives/*.deb

echo "install python pips  ##########################################################################" \
    && export pipslist="ansible openshift pymongo hvac inquirer termcolor art yopass-api bcrypt crypto kafka-python kubernetes pyaml" \
    && export agalaxylist="community.general kubernetes.core community.mongodb community.hashi\_vault" \
    && echo "export VENV_DIR=/var/venv" >> ~/.bashrc \
    && source ~/.bashrc \
    && ( test -e $VENV_DIR || mkdir -p $VENV_DIR ) \
    && for u in sshuser piper blobby bob ansible; do \
        grep -q "export VENV_DIR="                 /home/$u/.bashrc || echo "export VENV_DIR=$VENV_DIR"        >> /home/$u/.bashrc ; \
        grep -q "source $VENV_DIR/$u/bin/activate" /home/$u/.bashrc || echo "source $VENV_DIR/$u/bin/activate" >> /home/$u/.bashrc ; \
        test -e $VENV_DIR/$u || python3 -m venv $VENV_DIR/$u ; \
        chmod a+r+w+x -R $VENV_DIR/$u ; \
        su --login $u -c bash -c "source $VENV_DIR/$u/bin/activate ; pip install $pipslist ; ansible-galaxy collection install --ignore-errors $agalaxylist" ; \
        done \
    && chmod a+r+w+x -R $VENV_DIR 
