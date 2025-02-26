
##     ## ######## ##       ########  ######## ########  
##     ## ##       ##       ##     ## ##       ##     ## 
##     ## ##       ##       ##     ## ##       ##     ## 
######### ######   ##       ########  ######   ########  
##     ## ##       ##       ##        ##       ##   ##   
##     ## ##       ##       ##        ##       ##    ##  
##     ## ######## ######## ##        ######## ##     ## 

function futils () {
    local cmd=$1
    test "$cmd" == "" && cmd=$(type $FUNCNAME | grep selector | grep -v grep | sort | cut -d'"' -f2 | fzf)

    case $cmd in
        "rpwd-date" | "selector" ) 
            rpwd1
            echo "use fmtex-hide-yopass-message"
            return
        ;;

        "rpwd-random" | "selector" ) 
            rpwd2
            echo "use fmtex-hide-yopass-message"
            return
        ;;

        "rpwd-readable" | "selector" ) 
            rpwd3
            echo "use fmtex-hide-yopass-message"
            return
        ;;

        "rpwd-openssl" | "selector" ) 
            rpwd4
            echo "use fmtex-hide-yopass-message"
            return
        ;;

        "rpwd-all-and-hide" | "selector" ) rpwd ; return;;

        "vault" | "selector" ) fvault-cli ; return ;;

        "hide" | "selector" ) 
            read -p 'Enter secret word to hide: ' spassword
            fmtex-hide-yopass-message "$spassword"
            return
        ;;

        "chown-all-piper" | "selector" ) 
            chown -R piper:piper .
            return
        ;;

        "helper-tmp-temporary-scripts" | "selector" ) 
            local lpath="~/home_cnf/temporary-scripts/"
            ls -1 $lpath | fzf | xargs bash 
            return
        ;;



        * ) 
            >&2 echo "wrong command:   $cmd"
            >&2 echo "available commands are:"
            type $FUNCNAME | grep selector | grep -v grep | sort | cut -d'"' -f2
        ;;

    esac

}

alias fu=futils