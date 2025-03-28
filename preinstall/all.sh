#!/bin/bash

cat >> /dev/null << EOF
url_base=https://raw.githubusercontent.com/shkodina/home-cnf-common-library/refs/heads/main/preinstall
apt update
apt install -y curl
curl $url_base/all.sh
curl $url_base/all.sh | bash
EOF

url_base=https://raw.githubusercontent.com/shkodina/home-cnf-common-library/refs/heads/main/preinstall

curl ${url_base}/00-base.sh     | bash
curl ${url_base}/01-vault.sh    | bash
curl ${url_base}/02-docker.sh   | bash
curl ${url_base}/03-db.sh       | bash
curl ${url_base}/04-netutils.sh | bash
curl ${url_base}/05-users.sh    | bash
curl ${url_base}/06-python.sh   | bash
curl ${url_base}/07-k8s.sh      | bash
curl ${url_base}/08-boosters.sh | bash
curl ${url_base}/09-terra.sh    | bash
curl ${url_base}/10-yc.sh       | bash

