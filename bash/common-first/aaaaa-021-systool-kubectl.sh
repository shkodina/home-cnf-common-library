

command -v kubectl && source <(kubectl completion bash)

alias kc='kubectl'
complete -F __start_kubectl kc

command -v kubectl && complete -F __start_kubectl kc

function fkc-gen-full-config-from-splited-configs () {
    export KUBECONFIGS_DIR="~/.kube/splited_kubeconfigs/configs/"
    export KUBECONFIG=$(find ${KUBECONFIGS_DIR} -type f | tr '\n' ':')
    kubectl config view --flatten > ~/.kube/config
}
