function sshtmp () {
    ssh -o "ConnectTimeout 3" \
        -o "StrictHostKeyChecking no" \
        -o "UserKnownHostsFile /dev/null" \
            "$@"
}

function fssh-key-gen () {
    local folder="/tmp/$(date '+%s')"
    mkdir -p $folder
    ssh-keygen -t rsa -b 1024 -N "" -f $folder/id_rsa -q 
    find $folder -type f
}
