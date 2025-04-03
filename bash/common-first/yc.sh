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
