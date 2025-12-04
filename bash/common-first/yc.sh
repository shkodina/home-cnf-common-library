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

function fyc-get-vmid () {
    local vm=$(yc compute instance list --format json | jq -r .[].name | fzf)
    local vmid=$(yc compute instance get --name $vm --format json | jq -r .id)
    echo $vmid
}

function fyc-ssh () {
    yc compute ssh   --id $(fyc-get-vmid)   --identity-file ~/.ssh/id_rsa
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
    type $FUNCNAME | grep selector | grep -v grep | cut -d'"' -f2 | grep -E ".*$1.*" | wc -l | xargs test 1 -eq \
        && local cmd=$( type $FUNCNAME | grep selector | grep -v grep | cut -d'"' -f2 | grep -E ".*$1.*" ) \
        || local cmd=$( type $FUNCNAME | grep selector | grep -v grep | cut -d'"' -f2 | grep -E ".*$1.*" | fzf )

    case $cmd in
        "list" | "selector" ) 
            yc compute instance list
        return ;; 

        "get" | "selector" ) 
            local vmname=$(yc compute instance list | grep central | fzf | cut -d'|' -f3 | tr -d ' ')
            yc compute instance get --name $vmname --format json
        return ;; 

        "up" | "start" | "selector" ) 
            local vmname=$(yc compute instance list | grep STOPPED | fzf | cut -d'|' -f3 | tr -d ' ')
            yc compute instance start --name $vmname
        return ;; 

        "down" | "stop" | "selector" ) 
            local vmname=$(yc compute instance list | grep RUNNING | fzf | cut -d'|' -f3 | tr -d ' ')
            yc compute instance stop --name $vmname
        return ;; 

        "delete" | "rm" | "selector" ) 
            local vmname=$(yc compute instance list | grep central | fzf | cut -d'|' -f3 | tr -d ' ')
            yc compute instance delete --name $vmname
        return ;; 

        "operations" | "selector" ) 
            local vmname=$(yc compute instance list | grep central | fzf | cut -d'|' -f3 | tr -d ' ')
            yc compute instance list-operations --name $vmname
        return ;; 

        * ) 
            >&2 echo "wrong command:   $cmd"
            >&2 echo "available commands are:"
            type $FUNCNAME | grep selector | grep -v grep | cut -d'"' -f2
            return
        ;;
    esac
}