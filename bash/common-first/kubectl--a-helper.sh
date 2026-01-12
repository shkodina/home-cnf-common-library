##     ## ######## ##       ########  ######## ########  
##     ## ##       ##       ##     ## ##       ##     ## 
##     ## ##       ##       ##     ## ##       ##     ## 
######### ######   ##       ########  ######   ########  
##     ## ##       ##       ##        ##       ##   ##   
##     ## ##       ##       ##        ##       ##    ##  
##     ## ######## ######## ##        ######## ##     ## 

function fkc () {
    local cmdc=$( type $FUNCNAME | grep selector | grep -v grep | cut -d'"' -f2 | grep -E ".*$1.*" | wc -l )
    local cmd=
    [ $cmdc -lt 1 ] && cmd=
    [ $cmdc -eq 1 ] && cmd=$( type $FUNCNAME | grep selector | grep -v grep | cut -d'"' -f2 | grep -E ".*$1.*" )
    [ $cmdc -gt 1 ] && cmd=$( type $FUNCNAME | grep selector | grep -v grep | cut -d'"' -f2 | grep -E ".*$1.*" | fzf )

    case $cmd in
        "node-debug"              | "selector" ) fkc-$cmd ; return ;;
        "node-ssh"                | "selector" ) fkc-$cmd ; return ;;
        "node-show-non-term-pods" | "selector" ) fkc-$cmd ; return ;;
        "node-cordone"            | "selector" ) fkc-$cmd ; return ;;
        "node-uncordone"          | "selector" ) fkc-$cmd ; return ;;
        "node-drain"              | "selector" ) fkc-$cmd ; return ;;
        "node-shell"              | "selector" ) fkc-$cmd ; return ;;
        "node-disable"            | "selector" ) fkc-$cmd ; return ;;
        "node-enable"             | "selector" ) fkc-$cmd ; return ;;

        "pod-limits"     | "selector" ) fkc-$cmd ; return ;;
        "pod-kill"       | "selector" ) fkill    ; return ;;
        "pod-cleanup"    | "selector" ) fkc-$cmd ; return ;;
        "pod-debug"      | "selector" ) fkc-$cmd ; return ;;
        "pod-port-proxy" | "selector" ) fkc-$cmd ; return ;;

        "pv-kill"         | "selector" ) fkc-$cmd ; return ;;
        "pvc-kill"        | "selector" ) fkc-$cmd ; return ;;
        "pvc-full-delete" | "selector" ) fkc-$cmd ; return ;;

        "cron" | "selector" ) fcj ; return ;; 

        "scale-deploy" | "selector" ) 
            [ -z "$2" ] && {
                read -p 'set new count: ' ccount 
                fscale_replica_deployment $ccount
            } || fscale_replica_deployment $2 
            return 
        ;; 

        "scale-sts" | "selector" ) 
            [ -z "$2" ] && {
                read -p 'set new count: ' ccount 
                fscale_replica_sts_statefullset $ccount
            } || fscale_replica_sts_statefullset $2 
            return 
        ;; 

        "ctx-list" | "selector" ) 
          >&2 echo "kubectl config get-contexts -o name"
          kubectl config get-contexts -o name ; 
          return ;; 

        "ctx"      | "selector" ) kubectl config view --minify -o jsonpath='{.current-context}' ; return ;; 

        "ns"       | "selector" ) kubectl config view --minify -o jsonpath='{..namespace}' ; return ;; 
        "ns-kill"  | "selector" ) fkc-$cmd ; return ;;

        "svc-kill" | "selector" ) fkc-$cmd ; return ;;

        "rollout-deploy"      | "selector" ) fkc-$cmd ; return ;;
        "rollout-statefulset" | "selector" ) fkc-$cmd ; return ;;

        "secret-data"              | "selector" ) fgetsecretdata ; return ;;
        "secret-tls"               | "selector" ) fgetsecretdata-from-tls ; return ;;
        "tls-expires-ends-in"      | "selector" ) fkc-$cmd ; return ;;

        "info"        | "selector" ) fginfo ; return ;;
        "info-full"   | "selector" ) fginfo-full ; return ;;


        "token-review" | "selector" ) echo "call: fkc-token-review  <token>" ; return ;;

        * ) 
            >&2 echo "wrong command:   $cmd"
            >&2 echo "available commands are:"
            type $FUNCNAME | grep selector | grep -v grep | cut -d'"' -f2
            return
        ;;
    esac
}
