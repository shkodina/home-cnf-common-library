#!/bin/bash
>&2 echo "
apt update && apt install -y curl && curl https://raw.githubusercontent.com/shkodina/home-cnf-common-library/refs/heads/main/preinstall/all.sh | bash
"

url_base=https://raw.githubusercontent.com/shkodina/home-cnf-common-library/refs/heads/main/preinstall
curl ${url_base}/prepare-base.sh | bash
