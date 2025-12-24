# https://raw.githubusercontent.com/shkodina/home-cnf-common-library/refs/heads/main/bash/common-first/yc.sh

function yc-activate-profile () {
    local profile=$(yc config profile list | cut -d ' ' -f1 | fzf)
    yc config profile activate ${profile}
    sed -i "/YC_TOKEN=/d" ~/.bashrc
    export YC_TOKEN=$(yc iam create-token)
    export YC_CLOUD_ID=$(yc config get cloud-id)
    export YC_FOLDER_ID=$(yc config get folder-id)
}
alias fyc-profile-activate=yc-activate-profile

function fyc-set-external-yc-token () {
    sed -i "/YC_TOKEN=/d" ~/.bashrc
    echo export YC_TOKEN=$1 | tee -a ~/.bashrc
}

function fyc-subnet-list () {
    yc vpc subnet list --format json | yq .[].name
}

function fyc-subnet-list-used-ip () {
    local snet=$(fyc-subnet-list | fzf)
    echo yc vpc subnet list-used-addresses --name $snet >&2
    yc vpc subnet list-used-addresses --name $snet --format json | 
    jq -c .[] | 
    while read sss; 
    do 
        local ip=$(echo $sss | yq .address)
        local ref=$(echo $sss | yq .references.[].referrer.type)
        echo "$ip|$ref"
    done
}

function fyc-cert-request-get-txt-records () {
  yc resource-manager folder list --format json | 
  jq -r .[].name | 
  while read fldname; 
  do 
    yc certificate-manager certificate list \
        --folder-name ${fldname} \
        --format json --full | jq -c .[] | 
    grep 'yc.lime-shop.com' | 
    grep PENDING'' | 
    jq -r .name |
    while read certname;
    do
      yc certificate-manager certificate get \
        --folder-name ${fldname} \
        --name ${certname} \
        --format json --full | 
        jq -r .challenges |
        jq -c .[] |
        grep '"type":"TXT"'
    done 
  done |
  while read challenge;
  do
    name=$(echo ${challenge} | jq -r .dns_challenge.name)
    type=$(echo ${challenge} | jq -r .dns_challenge.type)
    value=$(echo ${challenge} | jq -r .dns_challenge.value)
    # echo -e "${type}|${name}|${value}"
    echo -e "\nNAME: ${name}\nVALUE: ${value}\n"
  done
}

function fyc-vm () {
    local cmdls=$(mktemp); type $FUNCNAME | grep '"local-in-case-cmd-selector"' | grep -v grep | tr \" \\n | grep -v -E "\||\)|local-in-case-cmd-selector|^ *$" | grep -E ".*$1.*" > $cmdls
    local cmdc=$( cat $cmdls | wc -l )
    local cmd=
    [ $cmdc -lt 1 ] && cmd=
    [ $cmdc -eq 1 ] && cmd=$( cat $cmdls )
    [ $cmdc -gt 1 ] && cmd=$( cat $cmdls | fzf )

    case $cmd in
        "list" | "local-in-case-cmd-selector" ) 
            yc compute instance list
        return ;; 

        "get" | "local-in-case-cmd-selector" ) 
            local vmname=$(yc compute instance list | grep central | fzf | cut -d'|' -f3 | tr -d ' ')
            yc compute instance get --name $vmname --format json
        return ;; 

        "up" | "start" | "local-in-case-cmd-selector" ) 
            local vmname=$(yc compute instance list | grep STOPPED | fzf | cut -d'|' -f3 | tr -d ' ')
            yc compute instance start --name $vmname
        return ;; 

        "down" | "stop" | "local-in-case-cmd-selector" ) 
            local vmname=$(yc compute instance list | grep RUNNING | fzf | cut -d'|' -f3 | tr -d ' ')
            yc compute instance stop --name $vmname
        return ;; 

        "delete" | "rm" | "local-in-case-cmd-selector" ) 
            local vmname=$(yc compute instance list | grep central | fzf | cut -d'|' -f3 | tr -d ' ')
            yc compute instance delete --name $vmname
        return ;; 

        "operations" | "local-in-case-cmd-selector" ) 
            local vmname=$(yc compute instance list | grep central | fzf | cut -d'|' -f3 | tr -d ' ')
            yc compute instance list-operations --name $vmname
        return ;; 

        "ssh" | "connect" | "local-in-case-cmd-selector" ) 
            local vmname=$(yc compute instance list | grep central | fzf | cut -d'|' -f3 | tr -d ' ')
            local primary_v4_address=$(yc compute instance get --name $vmname --format json | jq -r .network_interfaces[].primary_v4_address.address | grep 10.198)
            >&2 echo "ssh $primary_v4_address"
            ssh $primary_v4_address
        return ;; 

        * ) 
            >&2 echo "wrong command:   $cmd"
            >&2 echo "available commands are:"
            type $FUNCNAME | grep local-in-case-cmd-selector | grep -v grep | cut -d'"' -f2
            return
        ;;
    esac
}