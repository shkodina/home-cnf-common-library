#!/bin/bash
>&2 echo "
apt update ; apt install -y curl ; curl https://raw.githubusercontent.com/shkodina/home-cnf-common-library/refs/heads/main/preinstall/all.sh | bash
"

url_base=https://raw.githubusercontent.com/shkodina/home-cnf-common-library/refs/heads/main/preinstall
curl ${url_base}/00-base.sh   | bash
curl ${url_base}/01-vault.sh  | bash
curl ${url_base}/02-docker.sh | bash
curl ${url_base}/03-db.sh     | bash
