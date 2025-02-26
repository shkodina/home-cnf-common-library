#!/bin/bash

echo "INSTALL UTILS ########################################################################" \
    && apt update && apt upgrade -y \
    && apt install -y \
        lsb-release \
    && rm -rf /var/lib/apt/lists/* \
    && rm -f /var/cache/apt/archives/*.deb

##     ##  #######  ##    ##  ######    #######  
###   ### ##     ## ###   ## ##    ##  ##     ## 
#### #### ##     ## ####  ## ##        ##     ## 
## ### ## ##     ## ## ## ## ##   #### ##     ## 
##     ## ##     ## ##  #### ##    ##  ##     ## 
##     ## ##     ## ##   ### ##    ##  ##     ## 
##     ##  #######  ##    ##  ######    #######  

msh=mongosh-2.2.6-linux-x64 && \
    mt=mongodb-database-tools-ubuntu2204-x86_64-100.9.4 && \
    wget https://downloads.mongodb.com/compass/$msh.tgz && \
    wget https://fastdl.mongodb.org/tools/db/$mt.tgz && \
    tar -xzvf $msh.tgz && \
    tar -xzvf $mt.tgz && \
    chmod a+x $msh/bin/* && \
    chmod a+x $mt/bin/* && \
    mv $msh/bin/* /bin && \
    mv $mt/bin/* /bin && \
    rm -rf $msh $mt $msh.* $mt.*

echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-6.0.list && \
    wget --quiet -O - https://www.mongodb.org/static/pgp/server-6.0.asc  | gpg --dearmor -o /etc/apt/trusted.gpg.d/mongodb-6.gpg && \
    apt update && \
    apt install -y mongodb-org && \
    rm -rf /var/lib/apt/lists/* && \
    rm -f /var/cache/apt/archives/*.deb

########  ######## ########  ####  ######  
##     ## ##       ##     ##  ##  ##    ## 
##     ## ##       ##     ##  ##  ##       
########  ######   ##     ##  ##   ######  
##   ##   ##       ##     ##  ##        ## 
##    ##  ##       ##     ##  ##  ##    ## 
##     ## ######## ########  ####  ######  

apt update && \
    apt install -y redis-tools && \
    rm -rf /var/lib/apt/lists/* && \
    rm -f /var/cache/apt/archives/*.deb

########   #######   ######  ########  ######   ########  ########  ######  
##     ## ##     ## ##    ##    ##    ##    ##  ##     ## ##       ##    ## 
##     ## ##     ## ##          ##    ##        ##     ## ##       ##       
########  ##     ##  ######     ##    ##   #### ########  ######    ######  
##        ##     ##       ##    ##    ##    ##  ##   ##   ##             ## 
##        ##     ## ##    ##    ##    ##    ##  ##    ##  ##       ##    ## 
##         #######   ######     ##     ######   ##     ## ########  ######    

echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list && \
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor -o /etc/apt/trusted.gpg.d/postgresql.gpg && \
    apt update && \
    apt install -y postgresql-client-16 && \
    rm -rf /var/lib/apt/lists/* && \
    rm -f /var/cache/apt/archives/*.deb

##     ## ##    ##  ######   #######  ##       
###   ###  ##  ##  ##    ## ##     ## ##       
#### ####   ####   ##       ##     ## ##       
## ### ##    ##     ######  ##     ## ##       
##     ##    ##          ## ##  ## ## ##       
##     ##    ##    ##    ## ##    ##  ##       
##     ##    ##     ######   ##### ## ########

apt update && \
    apt install -y mysql-client && \
    rm -rf /var/lib/apt/lists/* && \
    rm -f /var/cache/apt/archives/*.deb
