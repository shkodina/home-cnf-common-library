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

