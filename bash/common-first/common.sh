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
    local tdir=${1:-"/tmp/$(fddate)"}
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

function ftool-list-all-colors (){
    for i in {1..50}; do echo -e "\033[0;${i}m SOME Color of 0 ${i} \033[0m" ; echo -e "\033[1;${i}m SOME Color of 1 ${i} \033[0m"; done;
    echo '\033[_;_m'
    set | grep -E "^CLR_.*"
}
alias fcolors=ftool-list-all-colors

function ffind () {
    find . -type f -iname "*$1*"
}
