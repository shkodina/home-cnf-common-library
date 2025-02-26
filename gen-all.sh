#!/bin/bash

find bash -type f -name "*.sh" | 
sort | 
xargs cat |
sed "s/ *$//g" |
sed "/^ *$/d" |
cat > all.sh
