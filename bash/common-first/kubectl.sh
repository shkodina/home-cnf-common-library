 ######   ######## ######## 
##    ##  ##          ##    
##        ##          ##    
##   #### ######      ##    
##    ##  ##          ##    
##    ##  ##          ##    
 ######   ########    ##   

function fget-src () { 
    kubectl api-resources | fzf | cut -d' ' -f1
}

function fget_helper () { 
  test -z $1 \
  && kubectl get $(fget-src) --no-headers \
  || kubectl get $1 --no-headers 
}

function fget () { 
  local list=$(fget_helper $1) 
  echo -e "$list" | fzf | f1
}

function fgetm () { 
  local list=$(fget_helper $1) 
  echo -e "$list" | fzf -m | f1
}

function fgy () {  # $1 = k8s source name  $2 = source name
  local src_name=${1:-$(fget-src)}
	local obj_name=${2:-$(fgetm $src_name)}
  kubectl get $src_name $obj_name -oyaml
}	

function fgy-meta(){
  fgy $1 $2 | yq -r .metadata
}

######## ##     ## ########  ######  
##        ##   ##  ##       ##    ## 
##         ## ##   ##       ##       
######      ###    ######   ##       
##         ## ##   ##       ##       
##        ##   ##  ##       ##    ## 
######## ##     ## ########  ######  

function fexe () {
    kubectl exec $(kubectl get -oname po | fzf) -- $@
}


function fexe-in-pod-by-mask-podname () {
   local podmask=$1
   shift
   for p in $(kubectl get -oname po | grep $podmask )
   do
     kubectl exec $p -- $@
   done
}

########  ########  ######   ######  
##     ## ##       ##    ## ##    ## 
##     ## ##       ##       ##       
##     ## ######    ######  ##       
##     ## ##             ## ##       
##     ## ##       ##    ## ##    ## 
########  ########  ######   ######  

function fdesc () {  # $1 = k8s source name  $2 = pod name
        local src_name=$1
        test -z $src_name && src_name=$(kubectl api-resources | fzf | cut -d' ' -f1)
	test -z $2 && for x in $(fgetm $src_name) ; do  kubectl describe $src_name $x ; done
	test -z $2 || { shift ; for x in $@ ; do  kubectl describe $src_name $x ; done ;}
}

########  ######## ##       
##     ## ##       ##       
##     ## ##       ##       
##     ## ######   ##       
##     ## ##       ##       
##     ## ##       ##       
########  ######## ######## 

function fdel () {  # $1 = k8s source name  $2 = pod name
  local src_name=$1
  test -z $src_name && src_name=$(kubectl api-resources | fzf | cut -d' ' -f1)
  test -z $2 && kubectl delete $src_name $(fgetm $src_name)
  test -z $2 || kubectl delete $src_name $2
}

function fdel-A () {  # $1 = k8s source name
  local src_name=$1
  test -z $src_name && src_name=$(kubectl api-resources | fzf | cut -d' ' -f1)
  kubectl get $src_name -A | fzf -m | while read ns src stuff;
  do
    >&2 echo "kubectl -n $ns delete $src_name $src"
    kubectl -n $ns delete $src_name $src
  done
}

######## ########  #### ######## 
##       ##     ##  ##     ##    
##       ##     ##  ##     ##    
######   ##     ##  ##     ##    
##       ##     ##  ##     ##    
##       ##     ##  ##     ##    
######## ########  ####    ##  

function fedit () {  # $1 = k8s source name  $2 = source name
        local src_name=$1
        test -z $src_name && src_name=$(kubectl api-resources | fzf | cut -d' ' -f1)
        test -z $2 \
                && kubectl edit $src_name $(fget $src_name) \
                || kubectl edit $src_name $2
}

######## ######## ######## 
##       ##       ##       
##       ##       ##       
######   ######   ######   
##       ##       ##       
##       ##       ##       
##       ######## ######## 

function fee () {
	kubectl exec --stdin --tty $(fget pod) -- sh -c '(bash||sh)'
}

function fee-in-container () {
  if [ -z $1 ]  #  no pod no container
  then
    local pp=$(fget pods)
    local cc=$(fgetcontainerfrompod $pp | fzf)     
  else  #  selected container
    local cc=$1
    test -z $2 && local pp=$(fget pods) || pp=$2
  fi
  kubectl exec --stdin --tty $pp -c $cc -- sh -c '(bash||sh)'
}

alias fee-c=fee-c

   ###    ##       ####    ###     ######  ########  ######  
  ## ##   ##        ##    ## ##   ##    ## ##       ##    ## 
 ##   ##  ##        ##   ##   ##  ##       ##       ##       
##     ## ##        ##  ##     ##  ######  ######    ######  
######### ##        ##  #########       ## ##             ## 
##     ## ##        ##  ##     ## ##    ## ##       ##    ## 
##     ## ######## #### ##     ##  ######  ########  ######  


alias fkc-kill='fkill'
alias fkc-url='tail -n +2 | while read ii ss uri tt; do for iii in $(echo $uri | tr "," "\ "); do printf "%-60s %s\n" $ii http://$iii ; done ; done'
alias url='fkc-url'
alias kc='kubectl '
alias ke='kubie'

alias g='kc get '
alias gwide='kc get -owide'
alias gname='kc get -oname'
alias gyaml='kc get -oyaml'

alias k9s='docker run --rm -it -v ~/.kube/config:/root/.kube/config quay.io/derailed/k9s'

alias grlb='kubectl get rolebindings'

alias xkcd='xargs kubectl delete'
alias xkcgy='xargs kubectl get -o yaml'

##    ## ######## ##    ## 
##   ##  ##       ###   ## 
##  ##   ##       ####  ## 
#####    ######   ## ## ## 
##  ##   ##       ##  #### 
##   ##  ##       ##   ### 
##    ## ######## ##    ## 

function ken () {
  local nslist=$(kubectl get ns -oname | cut -d'/' -f2- | grep ".*$1.*")
    
  test "$(echo $nslist | tr ' ' '\n' | wc -l)" -gt "1" && {
    kubie ns $(echo $nslist | tr ' ' '\n' | fzf)
  } || {
    kubie ns ${nslist}
  }
}
