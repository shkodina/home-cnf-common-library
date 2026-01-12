########   #######  ########   ######  
##     ## ##     ## ##     ## ##    ## 
##     ## ##     ## ##     ## ##       
########  ##     ## ##     ##  ######  
##        ##     ## ##     ##       ## 
##        ##     ## ##     ## ##    ## 
##         #######  ########   ###### 

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

##    ##  #######  ########  ########  ######  
###   ## ##     ## ##     ## ##       ##    ## 
####  ## ##     ## ##     ## ##       ##       
## ## ## ##     ## ##     ## ######    ######  
##  #### ##     ## ##     ## ##             ## 
##   ### ##     ## ##     ## ##       ##    ## 
##    ##  #######  ########  ########  ######

function fkc-node-show-non-term-pods () {
  local maxl=$(for n in $(kc get no -oname); do echo $n | wc -c; done | sort -u | tail -n 1)
  printf "%-${maxl}s %-15s %s\n" NodeName PodCapacity PodNoneTerminatedState
  for n in $(kubectl get no -oname)
  do
    local nn=$(kubectl describe $n)
    local nname=$(echo -e "$nn" | grep -E "^Name:" | cut -d: -f2)
    local ncpod=$(echo -e "$nn" | grep -A 7 -E "^Capacity:" | grep pods: | cut -d: -f2)
    local nwpod=$(echo -e "$nn" | grep -E "^Non-terminated Pods:" | cut -d: -f2 | tr -c -d "[0-9]")
    printf "%-${maxl}s %-15s %s\n" $nname $ncpod $nwpod
  done
}


function fkc-node-ssh () {
  # local fuser="piper_al"
  test -z $KUBIE_ACTIVE && echo "NO KUBIE. EXIT"
  test -z $KUBIE_ACTIVE && return
  # local fnode=$(kc get nodes -oname | fzf)
  # local fip=$(kc get $fnode -oyaml  | yq -r .status.addresses[].address | grep -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')
  # echo "ssh ${fuser}@${fip}"
  # echo "Use passwd: ${GA_PIPER_AL_PWD}"
  # ssh ${fuser}@${fip}
  ssh $(kc get nodes -oname | fzf | xa kc get -oyaml | yq -r .status.addresses[].address | grep -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')
}


function fkc-node-debug () {
    local dimages="
    ubuntu:22.04
    nicolaka/netshoot
    harbor.yc.lime-shop.com/lime-devops/base-lime-devops-toolbox-helpfull-images/main/xtoolbox-6-worker:latest
    "
    local nnode=$(kubectl get node -oname | fzf )
    local udimage=$(echo $dimages | tr ' ' '\n' | fzf)
    kubectl debug $nnode -it --image=$udimage --profile=sysadmin
    kubectl get po -oname | grep node-debugger | grep ${nnode//node\/} | xargs kubectl delete
}


function fkc-node-cordone () { kubectl cordon $(fget node) ; }
function fkc-node-uncordone () { kubectl uncordon $(fget node) ; }
function fkc-node-drain () {
  local lnode=$(fget node)
  local keys=$(echo -e " \n --ignore-daemonsets \n --delete-emptydir-data " | fzf -m)
  echo kubectl drain $keys $lnode
  kubectl drain $keys $lnode
}

function fkc-node-prepare-tg-apply-worker () {
  local i=0
  kubectl get no | grep worker | while read w s; do echo $w; done | sort | while read w
  do
    cat << EOF
kubectl cordon $w;
sleep 10;
timeout -s SIGKILL 600 kubectl drain --ignore-daemonsets --delete-emptydir-data $w;
sleep 60;
terragrunt apply --auto-approve --target="yandex_compute_instance.instance[$i]";
sleep 600;
kubectl uncordon $w;
EOF
  ((i++))
  done
  
}

function fkc-node-shell () {
  kubectl node-shell $(kubectl get no -oname | cut -d / -f2 | fzf)
}

#######                                    
#       #    #   ##   #####  #      ###### 
#       ##   #  #  #  #    # #      #      
#####   # #  # #    # #####  #      #####  
#       #  # # ###### #    # #      #      
#       #   ## #    # #    # #      #      
####### #    # #    # #####  ###### ###### 

function fkc-node-enable () {
  test -z $KUBIE_ACTIVE && echo "NO KUBIE. EXIT"
  test -z $KUBIE_ACTIVE && return

  local lnode=$(kubectl get no -l node-role.kubernetes.io/worker="true" | fzf | cut -d' ' -f1)
  local lpree=$(kubectl get no -o yaml $lnode | yq -r .metadata.labels.preemptible)
  local lycvm=$(kubectl get no -o yaml $lnode | yq -r .metadata.labels.yc-vm-name)

  echo kubectl uncordon $lnode
  echo kubectl label node $lnode node-oper-state=not-schedule--false --overwrite

  kubectl uncordon $lnode
  kubectl label node $lnode node-oper-state=not-schedule--false --overwrite

  [ "$lpree" == "yes" ] && {
    echo kubectl label node $lnode preemptible-cj-ignore-up="false" --overwrite
    kubectl label node $lnode preemptible-cj-ignore-up="false" --overwrite
  }

  echo "yc compute instance start --name $lycvm"
}

######                                       
#     # #  ####    ##   #####  #      ###### 
#     # # #       #  #  #    # #      #      
#     # #  ####  #    # #####  #      #####  
#     # #      # ###### #    # #      #      
#     # # #    # #    # #    # #      #      
######  #  ####  #    # #####  ###### ###### 

function fkc-node-disable () {
  test -z $KUBIE_ACTIVE && echo "NO KUBIE. EXIT"
  test -z $KUBIE_ACTIVE && return

  local lnode=$(kubectl get no -l node-role.kubernetes.io/worker="true" | fzf | cut -d' ' -f1)
  local lpree=$(kubectl get no -o yaml $lnode | yq -r .metadata.labels.preemptible)
  local lycvm=$(kubectl get no -o yaml $lnode | yq -r .metadata.labels.yc-vm-name)

  echo kubectl cordon $lnode
  echo kubectl drain --ignore-daemonsets --delete-emptydir-data $lnode
  echo kubectl label node $lnode node-oper-state=not-schedule --overwrite

  kubectl cordon $lnode
  kubectl drain --ignore-daemonsets --delete-emptydir-data $lnode
  kubectl label node $lnode node-oper-state=not-schedule --overwrite

  [ "$lpree" == "yes" ] && {
    echo kubectl label node $lnode preemptible-cj-ignore-up="true" --overwrite
    kubectl label node $lnode preemptible-cj-ignore-up="true" --overwrite
  }

cat << EOF
kubectl -n kube-system get ds -o name | 
xargs kubectl -n kube-system rollout restart 
kubectl -n monitoring get ds -o name | 
xargs kubectl -n monitoring rollout restart 
kubectl -n metallb-system get ds -o name | 
xargs kubectl -n metallb-system rollout restart 
sleep 300
kubectl -n kube-system get po | grep Terminating | cut -d' ' -f1 | 
xargs kubectl -n kube-system delete pod --grace-period=0 --force
kubectl -n monitoring get po | grep Terminating | cut -d' ' -f1 | 
xargs kubectl -n monitoring delete pod --grace-period=0 --force
kubectl -n metallb-system get po | grep Terminating | cut -d' ' -f1 | 
xargs kubectl -n metallb-system delete pod --grace-period=0 --force
EOF

  echo "yc compute instance stop --name $lycvm"
}

########  ##     ##          ########  ##     ##  ######  
##     ## ##     ##          ##     ## ##     ## ##    ## 
##     ## ##     ##          ##     ## ##     ## ##       
########  ##     ##          ########  ##     ## ##       
##         ##   ##           ##         ##   ##  ##       
##          ## ##            ##          ## ##   ##    ## 
##           ###             ##           ###     ###### 

function fkc-pv-kill () {
  test "$1" == "" && kubectl patch pv $(kubectl get pv | grep Terminating | fzf | cut -d' ' -f1) -p '{"metadata": {"finalizers": null}}'
  test "$1" == "" || kubectl patch pv "$1" -p '{"metadata": {"finalizers": null}}'
}


function fkc-pvc-kill () {
  test "$1" == "" && kubectl patch pvc $(kubectl get pvc | grep Terminating | fzf | cut -d' ' -f1) -p '{"metadata": {"finalizers": null}}'
  test "$1" == "" || kubectl patch pvc "$1" -p '{"metadata": {"finalizers": null}}'
}


function fkc-pvc-full-delete () {
  local lpvcs=$1;
  test "${lpvcs}" == "" && lpvcs=$(kubectl get pvc | fzf -m | cut -d' ' -f1)
  for lpvc in ${lpvcs}
  do
    local lpv=$(kubectl get pvc -oyaml ${lpvc} | yq '.spec.volumeName')
    echo kubectl delete pvc ${lpvc}
    kubectl delete pvc ${lpvc}
    echo kubectl delete pv ${lpv}  
    kubectl delete pv ${lpv}  
  done
  return 0
}
