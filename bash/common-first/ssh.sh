function sshtmp () {
    ssh -o "ConnectTimeout 3" \
        -o "StrictHostKeyChecking no" \
        -o "UserKnownHostsFile /dev/null" \
            "$@"
}
