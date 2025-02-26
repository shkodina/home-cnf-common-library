function windnull () { $@ >>/dev/null 2>>/dev/null & }

function fwatch () {
  while true; do sleep 2; $@; done
}

function fsleep() {
    local secs=$1
    echo $1 | grep -q 's' && secs=$(echo $1 | tr -d 's')
    echo $1 | grep -q 'm' && secs=$(($(echo $1 | tr -d 'm') * 60))

    while [ $secs -gt 0 ]; do
        echo -ne ":$secs\033[0K\r"
        sleep 1
        : $((secs--))
    done    
}


function rtmp () {  # FUNCTION RANDOM TMP
    local fname=${1}__$(fdate)--$(fdate | md5sum | cut -d' ' -f1)
    touch /tmp/$fname
    echo /tmp/$fname
}

function fcd () { 
    cd $(dirname $(realpath $1))
}

function mkcdir ()
{
    local tdir=${1:-"/tmp/$(fdate)"}
    mkdir -p -- "$tdir" 
       cd -P -- "$tdir"
}

function sudoaptupdateaptupgrade () {
    export DEBIAN_FRONTEND=noninteractive
    sudo apt update 
    sudo apt upgrade -y 
    sudo apt autoremove
    sudo apt upgrade -y | 
        grep -q 'The following packages have been kept back:' && {
            echo 'run sudo apt-get --with-new-pkgs upgrade <list of packages kept back>'
        }
}
