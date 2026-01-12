alias fkc-kill-wide-alias='while read n p x ; do kubectl delete -n $n po $p --grace-period=0 --force; done'
alias fkc-delete-po-wide-alias='while read n p x ; do kubectl delete -n $n po $p; done'

function fkc-pod-limits () {
  
  local ns='NAMESPACE:.metadata.namespace'
  local pod="POD:.metadata.name"
  local container='CONTAINER:.spec.containers[*].name'
  local resource_req_mem='MEM_REQ:.spec.containers[*].resources.requests.memory'
  local resource_lim_mem='MEM_LIM:.spec.containers[*].resources.limits.memory'
  local resource_req_cpu='CPU_REQ:.spec.containers[*].resources.requests.cpu'
  local resource_lim_cpu='CPU_LIM:.spec.containers[*].resources.limits.cpu'

  kubectl get pod --chunk-size=0 -A -o custom-columns="$ns,$pod,$container,$resource_req_mem,$resource_lim_mem,$resource_req_cpu,$resource_lim_cpu"
}

#    # # #      #      
#   #  # #      #      
####   # #      #      
#  #   # #      #      
#   #  # #      #      
#    # # ###### ###### 

function fkill () {  # $1 = pod name
        local name=$1
        [ -z $name ] && { name=$(kubectl get pods | tail -n +2 | fzf -m | f1) ;  kubectl delete pod --grace-period=0 --force $name ; } \
                     || for pp in $* ; do kubectl delete pod --grace-period=0 --force $pp ; done
}

function fkc-pod-cleanup () {
  kubectl get po --chunk-size=0 -A | 
  grep -E "Completed|Unknown|Error|Terminating" | 
  while read ns po xxx; 
  do 
    kubectl -n $ns delete po $po   --grace-period=0 --force ; 
  done
}

function fkc-cp-to-pod () {
  local x=${1:?"Error. You must supply full path to file for copy"}
  kubectl cp $1 $(kubectl get po -oname | cut -d'/' -f2 | fzf):$1
}

function fkc-pod-port-proxy () {
  local pod=$(kubectl get po -oname | fzf)
  read -p 'set POD port: ' podport
  read -p 'set local port: ' lport
  echo kubectl port-forward $pod $lport:$podport
  kubectl port-forward $pod $lport:$podport
}

function fkc-pod-debug () {
    local dimages="
    harbor.tech.mvideo.ru/mvideoru/quasar/devops/maintenance/toolbox/master/quasar-toolbox-u22-full:latest
    harbor.tech.mvideo.ru/mvideoru/quasar/devops/maintenance/toolbox/master/quasar-toolbox-kafka-tools:latest
    harbor.tech.mvideo.ru/mvideoru/quasar/devops/maintenance/toolbox/master/quasar-toolbox-kafka-tools:0.0.1-101-8772e0de
    nicolaka/netshoot
    "
    local lpod=$(kubectl get po -oname | cut -d/ -f2 | fzf)
    local lconname=$(kubectl get po -oyaml $lpod | yq -r .spec.containers[].name | fzf)
    local udimage=$(echo $dimages | tr ' ' '\n' | fzf)

    kubectl debug -it $lpod --image=$udimage --target=$lconname
}
