#!/bin/bash
>&2 echo "### INFO-TO-ERR: run prehook"

find bash -type f -name "*.sh" | 
sort | 
xargs cat |
sed "s/ *$//g" |
sed "/^ *$/d" |
cat > all.sh

# find bash -type f -name "*.sh" | 
# sort | 
# xargs cat |
# cat > all.sh
