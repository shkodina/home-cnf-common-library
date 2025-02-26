   ###    ##       ####    ###     ######  ########  ######  
  ## ##   ##        ##    ## ##   ##    ## ##       ##    ## 
 ##   ##  ##        ##   ##   ##  ##       ##       ##       
##     ## ##        ##  ##     ##  ######  ######    ######  
######### ##        ##  #########       ## ##             ## 
##     ## ##        ##  ##     ## ##    ## ##       ##    ## 
##     ## ######## #### ##     ##  ######  ########  ######  

alias felastic='felk'

##     ## ######## ##       ########  ######## ########  
##     ## ##       ##       ##     ## ##       ##     ## 
##     ## ##       ##       ##     ## ##       ##     ## 
######### ######   ##       ########  ######   ########  
##     ## ##       ##       ##        ##       ##   ##   
##     ## ##       ##       ##        ##       ##    ##  
##     ## ######## ######## ##        ######## ##     ## 

function felk () {
  
    local cmd=$1
    test "$cmd" == "" && cmd=$(type $FUNCNAME | grep selector | grep -v grep | cut -d'"' -f2 | fzf)

    case $cmd in
        "chek-status-all-in-cluster" | "selector" ) 
              for i in `kubectl get ingress -A | grep elastic | grep -v kibana | awk '{print $4}'`;
              do
              G='\033[0;32m'; R='\033[0;31m'; N='\033[0m';
              res=`sudo curl  --silent -X GET $i/_cluster/health | jq .status`;
              if [ $res == '"green"' ]; then
                     echo -e "${N}$i - ${G}$res";
              else
                     echo -e "${N}$i - ${R}$res";
              fi;
              done;
            return
        ;;



        * ) 
            >&2 echo "wrong command:   $cmd"
            >&2 echo "available commands are:"
            type $FUNCNAME | grep selector | grep -v grep | cut -d'"' -f2
            return
        ;;
    esac

}
