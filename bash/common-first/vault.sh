########  #######   #######  ##        ######  
   ##    ##     ## ##     ## ##       ##    ## 
   ##    ##     ## ##     ## ##       ##       
   ##    ##     ## ##     ## ##        ######  
   ##    ##     ## ##     ## ##             ## 
   ##    ##     ## ##     ## ##       ##    ## 
   ##     #######   #######  ########  ######  


function fvault-add-value-to-server-from-vault-secret () {  #  $1=kv  $2=secret  $3=key  $4=vault-string
    test -z $4 && { echo 'Usage: cmd  (1)kv_name  (2)secret_name  (3)key  (4)vault_string_from_ansible' ; return 1 ; }
    local vval=$(avesdjs $4 | jq '.var_from_file' | cut -d '"' -f2)
    vault kv patch "$1"/"$2" "$3"="$vval"
}

function fvault-add-value-to-server-from-file-by-key () {  #  $1=kv  $2=secret  $3=file  $4=file-key $5=key 
    test -z $5 && { echo 'Usage: cmd  (1)kv_name  (2)secret_name  (3)file_from_ansible  (4)key_in_file  (5)key_for_hashicorp' ; return 1 ; }
    echo vault kv patch "$1"/"$2" "$5"="$(avesd-from-file-by-key $3 $4)"
    vault kv patch "$1"/"$2" "$5"="$(avesd-from-file-by-key $3 $4)"
}

function fvault-cli-reclone-selected-from-one-secret-to-another() {
    local sfrom=$1
    local sto=$2
    vault kv get -format=json $sfrom | 
        yq -P ".data.data|keys|.[]" | fzf -m | while read key
        do
            vault kv get -field=$key $sfrom | vault kv patch $sto $key=-
        done
}

function fvault-cli-get-secret-from-root () {  #  $1 path  $2 key(field)
    # echo $1 $2
    echo $2 | grep -q -E ".*/$" && {
        # раз заканчивается на слеш, то это не ключ, а дерево и потому копаем дальше
        fvault-cli-get-secret-from-root $1$2 $( (echo '.' ; vault kv list -format=json $1$2 | jq -r .[]) | fzf)
    } || {
        # раз в конце нет слеша, то это конечный ключ и его и надо вывести
        # >&2 echo "TIPS: vault kv get $1$2"
        echo $1$2 | sed 's/\.$//'
    }
}



function fvault-cli-get-value-from-root () {  #  $1 path  $2 key(field)
    # echo $1 $2
    echo $2 | grep -q -E ".*/$" && {
        # раз заканчивается на слеш, то это не ключ, а дерево и потому копаем дальше
        fvault-cli-get-value-from-root $1$2 $(vault kv list -format=json $1$2 | jq -r .[] | fzf)
    } || {
        # раз в конце нет слеша, то это конечный ключ и его и надо вывести
        # >&2 echo "TIPS: vault kv get $1$2"
        local f=$(vault kv get  -format=json $1$2 | jq '.data.data' | jq -r 'keys[]' | fzf)
        
        >&2 echo "CMD: vault kv get -field=$f $1$2"
        vault kv get -field=$f $1$2
    }
}

