
#    ######  ##     ##  #######  ##      ## 
#   ##    ## ##     ## ##     ## ##  ##  ## 
#   ##       ##     ## ##     ## ##  ##  ## 
#    ######  ######### ##     ## ##  ##  ## 
#         ## ##     ## ##     ## ##  ##  ## 
#   ##    ## ##     ## ##     ## ##  ##  ## 
#    ######  ##     ##  #######   ###  ### 

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

#    ######   ######  ##     ## 
#   ##    ## ##    ## ##     ## 
#   ##       ##       ##     ## 
#    ######   ######  ######### 
#         ##       ## ##     ## 
#   ##    ## ##    ## ##     ## 
#    ######   ######  ##     ## 

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

########  ######## ########  ##     ##  ######   
##     ## ##       ##     ## ##     ## ##    ##  
##     ## ##       ##     ## ##     ## ##        
##     ## ######   ########  ##     ## ##   #### 
##     ## ##       ##     ## ##     ## ##    ##  
##     ## ##       ##     ## ##     ## ##    ##  
########  ######## ########   #######   ###### 

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

#    ######   #######  ########  ########   #######  ##    ## 
#   ##    ## ##     ## ##     ## ##     ## ##     ## ###   ## 
#   ##       ##     ## ##     ## ##     ## ##     ## ####  ## 
#   ##       ##     ## ########  ##     ## ##     ## ## ## ## 
#   ##       ##     ## ##   ##   ##     ## ##     ## ##  #### 
#   ##    ## ##     ## ##    ##  ##     ## ##     ## ##   ### 
#    ######   #######  ##     ## ########   #######  ##    ## 

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

#    ######  ##     ## ######## ##       ##       
#   ##    ## ##     ## ##       ##       ##       
#   ##       ##     ## ##       ##       ##       
#    ######  ######### ######   ##       ##       
#         ## ##     ## ##       ##       ##       
#   ##    ## ##     ## ##       ##       ##       
#    ######  ##     ## ######## ######## ######## 

function fkc-node-shell () {
  kubectl node-shell $(kubectl get no -oname | cut -d / -f2 | fzf)
}

######## ##    ##    ###    ########  ##       ######## 
##       ###   ##   ## ##   ##     ## ##       ##       
##       ####  ##  ##   ##  ##     ## ##       ##       
######   ## ## ## ##     ## ########  ##       ######   
##       ##  #### ######### ##     ## ##       ##       
##       ##   ### ##     ## ##     ## ##       ##       
######## ##    ## ##     ## ########  ######## ######## 

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

########  ####  ######     ###    ########  ##       ######## 
##     ##  ##  ##    ##   ## ##   ##     ## ##       ##       
##     ##  ##  ##        ##   ##  ##     ## ##       ##       
##     ##  ##   ######  ##     ## ########  ##       ######   
##     ##  ##        ## ######### ##     ## ##       ##       
##     ##  ##  ##    ## ##     ## ##     ## ##       ##       
########  ####  ######  ##     ## ########  ######## ######## 

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
