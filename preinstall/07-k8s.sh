#!/bin/bash

echo "install helm  #################################################################################" \
    && curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash \
    && helm plugin install https://github.com/databus23/helm-diff 

echo "install kubectl  ##############################################################################" \
    && curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl \
    && rm kubectl 

echo "install kubie  ##############################################################################" \
    && wget -O kubie https://github.com/sbstp/kubie/releases/download/v0.25.1/kubie-linux-amd64 \
    && install -o root -g root -m 0755 kubie /usr/local/bin/kubie \
    && rm kubie 

echo "update bashrc  ##############################################################################" \
    && for u in sshuser piper blobby bob ansible; do \
        echo 'source /etc/bash_completion'       >> /home/$u/.bashrc ; \
        echo 'source <(helm completion bash)'    >> /home/$u/.bashrc ; \
        echo 'source <(kubectl completion bash)' >> /home/$u/.bashrc ; \
        echo 'alias kc=kubectl'                  >> /home/$u/.bashrc ; \
        done \
    && echo 'source /etc/bash_completion'       >> ~/.bashrc \
    && echo 'source <(helm completion bash)'    >> ~/.bashrc \
    && echo 'source <(kubectl completion bash)' >> ~/.bashrc \
    && echo 'alias kc=kubectl'                  >> ~/.bashrc  

echo "install yandex cloud cli = yc  ##############################################################################" \
    && curl -fsSL storage.yandexcloud.net/yandexcloud-yc/install.sh | bash

