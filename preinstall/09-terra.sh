#!/bin/bash

# echo "INSTALL TERAFORM TERAGROUND #################################################################################" \
#     && wget -O- https://apt.releases.hashicorp.com/gpg | \
#         gpg --dearmor | \
#         tee /usr/share/keyrings/hashicorp-archive-keyring.gpg \
#     && echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
#         tee /etc/apt/sources.list.d/hashicorp.list \
#     && apt update \
#     && apt upgrade -y \
#     && apt install -y \
#        gnupg \
#        software-properties-common \
#        terraform \
#     && rm -rf /var/lib/apt/lists/* \
#     && rm -f /var/cache/apt/archives/*.deb \
#     && terraform -install-autocomplete

echo "INSTALL TERAFORM TERAGROUND #################################################################################" \
    && wget 'https://www.dropbox.com/scl/fi/x24k95w6cyxfwtwincnl1/terraform_1.10.5-1_amd64.deb?rlkey=aet3kgsgo9yy8qujmvbtra55j&st=orjl34xf&dl=0' -O terraform_1.10.5-1_amd64.deb \
    && apt install ./terraform_1.10.5-1_amd64.deb \
    && rm -f ./terraform_1.10.5-1_amd64.deb \
    && terraform -install-autocomplete \
    && ln -s /usr/bin/terraform /usr/local/sbin/tf \
    && wget https://github.com/gruntwork-io/terragrunt/releases/download/v0.73.15/terragrunt_linux_amd64 -O terragrunt \
    && install terragrunt -o root -g root -m 0755 /usr/local/bin/terragrunt \
    && rm -f terragrunt \
    && ln -s /usr/local/bin/terragrunt /usr/local/sbin/tg


