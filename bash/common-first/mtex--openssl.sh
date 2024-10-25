########               ##       #### ########  
##                     ##        ##  ##     ## 
##                     ##        ##  ##     ## 
######                 ##        ##  ########  
##                     ##        ##  ##     ## 
##                     ##        ##  ##     ## 
##          #######    ######## #### ########  



       #######  ########  ######## ##    ##  ######   ######  ##       
      ##     ## ##     ## ##       ###   ## ##    ## ##    ## ##       
      ##     ## ##     ## ##       ####  ## ##       ##       ##       
      ##     ## ########  ######   ## ## ##  ######   ######  ##       
      ##     ## ##        ##       ##  ####       ##       ## ##       
      ##     ## ##        ##       ##   ### ##    ## ##    ## ##       
       #######  ##        ######## ##    ##  ######   ######  ######## 


            ########  #### ########  ######## ##       #### ##    ## ########  ######  
            ##     ##  ##  ##     ## ##       ##        ##  ###   ## ##       ##    ## 
            ##     ##  ##  ##     ## ##       ##        ##  ####  ## ##       ##       
            ########   ##  ########  ######   ##        ##  ## ## ## ######    ######  
            ##         ##  ##        ##       ##        ##  ##  #### ##             ## 
            ##         ##  ##        ##       ##        ##  ##   ### ##       ##    ## 
            ##        #### ##        ######## ######## #### ##    ## ########  ######  


function f_lib_openssl_mtex_enc_file_to_file () {
    openssl aes-256-cbc -a -salt -pbkdf2 -in $1 -out $2 -k "${QR_DEVOPS_OPENSSL_MASTER_KEY}"
}
function f_lib_openssl_mtex_dec_file_to_file () {
    openssl aes-256-cbc -d -a -pbkdf2 -in $1 -out $2 -k "${QR_DEVOPS_OPENSSL_MASTER_KEY}"
}


function f_lib_openssl_mtex_enc_file () {
    f_lib_openssl_mtex_enc_file_to_file $1 $1.encripted
}
function f_lib_openssl_mtex_dec_file () {
    f_lib_openssl_mtex_dec_file_to_file $1 $1.origin
}


function f_lib_openssl_mtex_dec_value () {
    echo "$1" > tmp.enc.data
    f_lib_openssl_mtex_dec_file_to_file tmp.enc.data tmp.dec.data
    cat tmp.dec.data
    rm -rf tmp.enc.data tmp.dec.data
}


function f_lib_openssl_mtex_enc_string () {
    echo "$1" | openssl enc -base64 -e -aes-256-cbc -salt -pass pass:$QR_DEVOPS_OPENSSL_MASTER_KEY -pbkdf2
}

function f_lib_openssl_mtex_dec_string () {
    echo "$1" | openssl enc -base64 -d -aes-256-cbc -salt -pass pass:$QR_DEVOPS_OPENSSL_MASTER_KEY -pbkdf2
}


##     ## ######## ##       ########  ######## ########  
##     ## ##       ##       ##     ## ##       ##     ## 
##     ## ##       ##       ##     ## ##       ##     ## 
######### ######   ##       ########  ######   ########  
##     ## ##       ##       ##        ##       ##   ##   
##     ## ##       ##       ##        ##       ##    ##  
##     ## ######## ######## ##        ######## ##     ## 

function flib-openssl () {
    local cmd=$1
    test "$cmd" == "" && cmd=$(type $FUNCNAME | grep selector | grep -v grep | sort | cut -d'"' -f2 | fzf)

    case $cmd in

        "enc_file_to_file" | "selector" ) 
            read -p 'set path to file with data: ' ldata
            read -p 'set path to file save encrypt to: ' lencdata
            set -o xtrace
            f_lib_openssl_mtex_enc_file_to_file  $ldata  $lencdata
            set +o xtrace
            return 
        ;;

        "dec_file_to_file" | "selector" ) 
            read -p 'set path to file with encrypted data: ' ldata
            read -p 'set path to file save decrypt to: ' ldecdata
            set -o xtrace
            f_lib_openssl_mtex_dec_file_to_file  $ldata  $ldecdata
            set +o xtrace
            return 
        ;;



        "enc_file" | "selector" ) 
            read -p 'set path to file with data: ' ldata
            set -o xtrace
            f_lib_openssl_mtex_enc_file  $ldata
            set +o xtrace
            return 
        ;;

        "dec_file" | "selector" ) 
            read -p 'set path to file with encrypted data: ' ldata
            set -o xtrace
            f_lib_openssl_mtex_dec_file  $ldata 
            set +o xtrace
            return 
        ;;

        "dec_value" | "selector" ) 
            read -p 'set value to encrypt: ' ldata
            set -o xtrace
            f_lib_openssl_mtex_dec_value  $ldata 
            set +o xtrace
            return 
        ;;

        "enc_string" | "selector" ) 
            read -p 'set string to encrypt: ' ldata
            set -o xtrace
            f_lib_openssl_mtex_enc_string  $ldata 
            set +o xtrace
            return 
        ;;

        "dec_string" | "selector" ) 
            read -p 'set string to decrypt: ' ldata
            set -o xtrace
            f_lib_openssl_mtex_dec_string  $ldata 
            set +o xtrace
            return 
        ;;



        "list-func" | "selector" )\
            declare -F | grep f_lib_openssl | cut -d' ' -f3
            return 
        ;;


        * ) 
            >&2 echo "wrong command:   $cmd"
            >&2 echo "available commands are:"
            type $FUNCNAME | grep selector | grep -v grep | sort | cut -d'"' -f2
        ;;

    esac

}

