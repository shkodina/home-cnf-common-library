
 ######  ########   #######  ##    ## 
##    ## ##     ## ##     ## ###   ## 
##       ##     ## ##     ## ####  ## 
##       ########  ##     ## ## ## ## 
##       ##   ##   ##     ## ##  #### 
##    ## ##    ##  ##     ## ##   ### 
 ######  ##     ##  #######  ##    ## 

function fcj () {
        local src_name=$1
        test -z $src_name && \
                src_name=$(kubectl get cj | tail -n +2 | fzf | cut -d' ' -f1)

        local act=$2
        test -z $act && \
                act=$(echo -e "suspend\nenable\nrun" | fzf)

        case $act in 
                "suspend" ) kubectl patch cronjobs $src_name -p '{"spec" : {"suspend" : true }}' ; return 0 ;;
                "enable"  ) kubectl patch cronjobs $src_name -p '{"spec" : {"suspend" : false }}' ; return 0 ;;
                "run" ) 
                        read -p "job name: " jobe_name
                        >&2 echo kubectl create job --from=cronjob/${src_name} ${jobe_name}
                        kubectl create job --from=cronjob/${src_name} ${jobe_name}
                        return 0 ;;
        esac
}



########  ######## ########  ##        #######  ##    ## 
##     ## ##       ##     ## ##       ##     ##  ##  ##  
##     ## ##       ##     ## ##       ##     ##   ####   
##     ## ######   ########  ##       ##     ##    ##    
##     ## ##       ##        ##       ##     ##    ##    
##     ## ##       ##        ##       ##     ##    ##    
########  ######## ##        ########  #######     ##  


function fscale_replica_deployment () {
        local src_count=${1:?"Error from $FUNCNAME. You must supply new count in FIRST parameter."}

        local src_count=$1

        local src_name=$2
        test -z $src_name && src_name=$(kubectl get deploy | tail -n +2 | fzf -m | cut -d' ' -f1) || { shift; src_name=$@ ;}

        for d in ${src_name}
        do
                echo "kubectl scale --replicas=${src_count} deployment/${d}"
                kubectl scale --replicas=${src_count} deployment/${d}
        done
}


function fkc-rollout-deploy () {
  test -z "$1" &&  { kubectl  rollout restart deployment $(fget deploy) && return ; }
  for d in $@
  do
    echo "$d" | grep -q 'deployment.apps' && d=$(echo $d | cut -d'/' -f2)
    kubectl  rollout restart deployment $d
  done
}


 ######  ########  ######  
##    ##    ##    ##    ## 
##          ##    ##       
 ######     ##     ######  
      ##    ##          ## 
##    ##    ##    ##    ## 
 ######     ##     ######  


function fscale_replica_sts_statefullset () {
        local src_count=${1:?"Error. You must supply new count in FIRST parameter."}

        local src_name=$2
        test -z $src_name && src_name=$(kubectl get sts | tail -n +2 | fzf -m | cut -d' ' -f1) || { shift; src_name=$@ ;}

        for d in ${src_name}
        do
                echo "kubectl scale --replicas=${src_count} statefulset.apps/${d}"
                kubectl scale --replicas=${src_count} statefulset.apps/${d}
        done
}


function fkc-rollout-statefulset () {
  test -z "$1" &&  { kubectl  rollout restart statefulset $(fget sts) && return ; }
  for d in $@
  do
    echo "$d" | grep -q 'statefulset.apps' && d=$(echo $d | cut -d'/' -f2)
    kubectl  rollout restart statefulset $d
  done
}

########   ######  
##     ## ##    ## 
##     ## ##       
##     ##  ######  
##     ##       ## 
##     ## ##    ## 
########   ######  

function fkc-rollout-daemonset () {
  test -z "$1" &&  { kubectl  rollout restart ds $(fget ds) && return ; }
  for d in $@
  do
    echo "$d" | grep -q 'daemonset.apps' && d=$(echo $d | cut -d'/' -f2)
    kubectl  rollout restart ds $d
  done
}
