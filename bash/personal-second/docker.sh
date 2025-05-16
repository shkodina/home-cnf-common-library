   ###    ##       ####    ###     ######  ########  ######  
  ## ##   ##        ##    ## ##   ##    ## ##       ##    ## 
 ##   ##  ##        ##   ##   ##  ##       ##       ##       
##     ## ##        ##  ##     ##  ######  ######    ######  
######### ##        ##  #########       ## ##             ## 
##     ## ##        ##  ##     ## ##    ## ##       ##    ## 
##     ## ######## #### ##     ##  ######  ########  ######  

alias docker='sudo docker '

##     ## ######## ##       ########  ######## ########  
##     ## ##       ##       ##     ## ##       ##     ## 
##     ## ##       ##       ##     ## ##       ##     ## 
######### ######   ##       ########  ######   ########  
##     ## ##       ##       ##        ##       ##   ##   
##     ## ##       ##       ##        ##       ##    ##  
##     ## ######## ######## ##        ######## ##     ## 

function fdocker () {
    local sudo_prefix=
    test "$(whoami)" == "root" || sudo_prefix=sudo
  
    local cmd=$1
    test "$cmd" == "" && cmd=$(type $FUNCNAME | grep selector | grep -v grep | cut -d'"' -f2 | fzf)

    case $cmd in
        "list-i" | "selector" ) 
            $sudo_prefix docker image list | while read n t tt; do echo $n:$t; done
            return
        ;;

        "list-i-size" | "selector" ) 
            $sudo_prefix docker image list --format "table {{.ID}}\t{{.Repository}}:{{.Tag}}\t{{.Size}}"
            return
        ;;

        "select-i" | "selector" ) 
            $FUNCNAME list-i | fzf
            return
        ;;

        "fee" | "selector" ) 
            local  cname=$(docker ps --format '{{json .}}' | jq -r .Names | fzf)
            docker exec -it $cname bash
            return
        ;;


        "clenup" | "selector" ) 
            $sudo_prefix docker image prune -af
            $sudo_prefix docker builder prune -af
            $sudo_prefix docker system prune -af
            return
        ;;

        "build" | "selector" ) 
            local docker_file=$(find . -iname "*dockerfile" | fzf)
            local docker_image_tmp_tag_name="x-$(basename $(dirname ${docker_file}) | tr -d -c '[a-z][A-Z][0-9]_.-' | sed 's/^\.*//')-to-delete:666.6.6-$(date +%N)"
            echo "$sudo_prefix docker build --pull --network host -t $docker_image_tmp_tag_name -f $docker_file ."
            $sudo_prefix docker build --pull --network host -t $docker_image_tmp_tag_name -f $docker_file .
            return
        ;;

        "open-pwd-dir-in-selected-image" | "selector" ) 
            local limage=$($FUNCNAME select-i)
            read -p 'enter port number for listen: ' lport
            set -o xtrace
            $sudo_prefix docker run --rm --name tmp-run-$$ \
                        -it \
                        -p ${lport:-"5000"}:${lport:-"5000"} \
                        -v ${PWD}:/tmp/${PWD##*/} \
                        --network host \
                        --workdir /tmp/${PWD##*/} \
                        "${limage}" \
                        /bin/sh 
            set +o xtrace
            return
        ;;



        "auth" | "selector" ) 
            local fd_user=${2}
            test -z $fd_user && read -p 'Enter User name: ' fd_user
            local fd_pass=${3}
            test -z $fd_pass && read -p 'Enter User pass/token: ' fd_pass
            local fd_url=${4}
            test -z $fd_url && read -p 'Enter registry url: ' fd_url

            local fd_data=$(
                kubectl create secret docker-registry pull-secret-by-piper \
                --docker-server "$fd_url" \
                --docker-username "$fd_user" \
                --docker-password "$fd_pass"  \
                --dry-run=client --output=yaml | 
                yq '.data.".dockerconfigjson"' )
            
            echo $fd_data
            echo $fd_data | base64 -d
            return
        ;;
 

        "auth-ga-by-token-to-get" | "selector" ) 
            local fd_user="TOKEN_TO_GET"

            local fd_pass=${2}
            test -z $fd_pass && read -p 'Enter User pass/token: ' fd_pass

            local fd_url="git.goldapple.ru:8443"

            local fd_data=$(
                kubectl create secret docker-registry pull-secret-by-piper \
                --docker-server "$fd_url" \
                --docker-username "$fd_user" \
                --docker-password "$fd_pass"  \
                --dry-run=client --output=yaml | 
                yq '.data.".dockerconfigjson"' )
            
            echo $fd_data
            echo $fd_data | base64 -d
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
