##     ## ######## ##       ########  ######## ########  
##     ## ##       ##       ##     ## ##       ##     ## 
##     ## ##       ##       ##     ## ##       ##     ## 
######### ######   ##       ########  ######   ########  
##     ## ##       ##       ##        ##       ##   ##   
##     ## ##       ##       ##        ##       ##    ##  
##     ## ######## ######## ##        ######## ##     ## 

function fk () {
    local cmd=$( type $FUNCNAME | grep selector | grep -v grep | cut -d'"' -f2 | grep -E ".*$1.*" | fzf )

    case $cmd in
        "get" | "selector" ) fget ; return ;; 



        "node-debug" | "selector" ) fkc-node-debug ; return ;;
        "node-ssh" | "selector" ) fkc-node-ssh-to ; return ;;
        "node-show-non-term-pods" | "selector" ) fkc-nodes-non-terminated-pods ; return ;;
        "node-cordone" | "selector" ) fkc-node-cordone ; return ;;
        "node-uncordone" | "selector" ) fkc-node-uncordone ; return ;;
        "node-drain" | "selector" ) fkc-node-drain ; return ;;
        "node-shell" | "selector" ) fkc-node-shell ; return ;;
        


        "pod-limits" | "selector" ) fkc-pods-with-limits ; return ;;
        "pod-kill" | "selector" ) fkill ; return ;;
        "pod-cleanup" | "selector" ) fkc-pods-cleanup ; return ;;
        "pod-port-proxy" | "selector" ) fkc-pods-port-proxy ; return ;;



        "pv-kill" | "selector" ) fkc-pv-force-delete ; return ;;
        "pvc-kill" | "selector" ) fkc-pvc-force-delete ; return ;;
        "pvc-delete-cascade" | "selector" ) fkc-pvc-full-delete ; return ;;



        "cron" | "selector" ) fcj ; return ;; 



        "scale-deploy" | "selector" ) 
            read -p 'set new count: ' ccout ;
            fscale_replica_deployment $ccount ; 
            return 
        ;; 

        "scale-sts" | "selector" ) 
            read -p 'set new count: ' ccout ;
            fscale_replica_sts_statefullset $ccount ; 
            return 
        ;; 



        "ctx-list" | "selector" ) 
          >&2 echo "kubectl config get-contexts -o name"
          kubectl config get-contexts -o name ; 
          return ;; 

        "ctx" | "selector" ) kubectl config view --minify -o jsonpath='{.current-context}' ; return ;; 

        "ns" | "selector" ) kubectl config view --minify -o jsonpath='{..namespace}' ; return ;; 
        "ns-kill" | "selector" ) fkc-ns-kill ; return ;;

        "svc-kill" | "selector" ) fkc-svc-kill ; return ;;


        "rollout-deploy" | "selector" ) fkc-rollout-deploy ; return ;;
        "rollout-sts" | "selector" ) fkc-rollout-statefulset ; return ;;



        "secret-data" | "selector" ) fgetsecretdata ; return ;;
        "secret-tls" | "selector" ) fgetsecretdata-from-tls ; return ;;



        "info" | "selector" ) fginfo ; return ;;
        "info-full" | "selector" ) fginfo-full ; return ;;


        "token-review" | "selector" ) echo "call: fkc-token-review  <token>" ; return ;;

        * ) 
            >&2 echo "wrong command:   $cmd"
            >&2 echo "available commands are:"
            type $FUNCNAME | grep selector | grep -v grep | cut -d'"' -f2
            return
        ;;
    esac
}
alias fkc=fk
