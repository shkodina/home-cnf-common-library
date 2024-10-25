# check init.scripts/vars/aliases.sh cert block

 ######  ######## ########  ######## 
##    ## ##       ##     ##    ##    
##       ##       ##     ##    ##    
##       ######   ########     ##    
##       ##       ##   ##      ##    
##    ## ##       ##    ##     ##    
 ######  ######## ##     ##    ##  

alias fssl-alias-cert-show-from-str='openssl x509 -noout -text'
alias fssl-alias-cert-show-from-b64='base64 -d | openssl x509 -noout -text'

##     ## ######## ##        ######  
###   ###    ##    ##       ##    ## 
#### ####    ##    ##       ##       
## ### ##    ##    ##        ######  
##     ##    ##    ##             ## 
##     ##    ##    ##       ##    ## 
##     ##    ##    ########  ######  

function fssl-create-cert-mtls() {
    local cert_name=$1  # Имя сертификата переданное как параметр
    if [ -z "$cert_name" ]; then
        echo "Ошибка: имя сертификата не указано."
        echo "Использование: $0 <имя_сертификата>"
        return 1
    fi
    # Путь к сертификату и ключу в Vault
    local CA_CERT_PATH="devops-internal/plaid/identity-certs/identity-certs-test"
    local CA_KEY_PATH="devops-internal/plaid/identity-certs/identity-certs-test"
 
 
    # Определение суффикса для даты
    local DATE_SUFFIX=$(date +"%d_%m_%Y")
 
    # Путь для хранения файлов с суффиксом
    local CSR_FILE="request_${cert_name}_${DATE_SUFFIX}.csr"
    local CERT_FILE="signed_${cert_name}_${DATE_SUFFIX}.crt"
    local KEY_FILE="key_${cert_name}_${DATE_SUFFIX}.pem"
 
    local PKCS12_FILE="${cert_name}_${DATE_SUFFIX}.pk12"
 
    # Создание временных файлов для корневого сертификата и ключа
    local TEMP_CA_CERT=$(mktemp)
    local TEMP_CA_KEY=$(mktemp)
 
    # 1. Генерация запроса на сертификат (CSR)
    openssl req -newkey rsa:4096 -nodes -keyout "$KEY_FILE" -out "$CSR_FILE" -subj "/C=RU/ST=SV/L=Obninsk/O=SelfDefend/OU=DevOps/CN=client"
 
    echo "CSR создан: $CSR_FILE"
 
    # 2. Получение корневого сертификата и ключа из Vault
    vault kv get -field=ca.crt "$CA_CERT_PATH" > "$TEMP_CA_CERT"
    vault kv get -field=ca.key "$CA_KEY_PATH" > "$TEMP_CA_KEY"
 
    # 3. Подписывание CSR с использованием корневого сертификата и ключа
    echo "Подписание CSR с использованием корневого сертификата и ключа..."
    openssl x509 -req -in "$CSR_FILE" -CA "$TEMP_CA_CERT" -CAkey "$TEMP_CA_KEY" -CAcreateserial -out "$CERT_FILE" -days 365 -sha256
 
    echo "Сертификат подписан: $CSR_FILE"
 
    # 4. Интерактивный выбор конвертации в формат PKCS#12
    echo "Хотите конвертировать сертификат и ключ в формат PKCS#12? (да/нет): "
    read CONVERT
 
    if [[ "$CONVERT" =~ ^[Дд]а$ ]]; then
        # Конвертация в формат PKCS#12
        openssl pkcs12 -in "$CERT_FILE" -inkey "$KEY_FILE" -export -out "$PKCS12_FILE" -passout pass:
 
        echo "Файл PKCS#12 создан: $PKCS12_FILE"
    else
        echo "Конвертация в формат PKCS#12 отменена."
    fi
 
 
    # Очистка временных файлов
    rm -f "$CSR_FILE" "$TEMP_CA_CERT" "$TEMP_CA_KEY"
 
    echo "Для быстрого теста сертификата можно использовать curl: "
    echo "curl -v --cert $CERT_FILE --key $KEY_FILE https://example.com"
    echo "В кодах ответа не должно быть 302 и рикрола"
}



export ANSIBLE_VAULT_PASSWORD_FILE_CONTENT="$(cat ${ANSIBLE_VAULT_PASSWORD_FILE})"

function fssl () {
    local cmd=$1
    test "$cmd" == "" && cmd=$(type $FUNCNAME | grep selector | grep -v grep | sort | cut -d'"' -f2 | fzf)

    case $cmd in
        "cert-show" | "selector" ) 
            read -p 'path to cert: ' lcert
            openssl x509 -noout -text -in "$lcert"
            return
        ;;



        "encrypt-str" | "selector" ) 
            local lstr=$2
            test -z $lstr && read -p 'str to encrypt: ' lstr
            local lpass=$3
            test -z $lpass && read -p 'password: ' lpass
            echo "$lstr" | openssl enc -base64 -aes-256-cbc -nosalt -pass pass:"$lpass" -e -A 2>>/dev/null
            return
        ;;

        "encrypt-str-by-vault" | "selector" ) 
            local lstr=$2
            test -z $lstr && read -p 'str to encrypt: ' lstr
            echo "$lstr" | openssl enc -base64 -aes-256-cbc -nosalt -pass pass:"$ANSIBLE_VAULT_PASSWORD_FILE_CONTENT" -e -A 2>>/dev/null
            return
        ;;



        "decrypt-str" | "selector" ) 
            local lstr=$2
            test -z $lstr && read -p 'str to encrypt: ' lstr
            local lpass=$3
            test -z $lpass && read -p 'password: ' lpass
            echo "$lstr" | openssl enc -base64 -aes-256-cbc -nosalt -pass pass:"$lpass" -d 2>>/dev/null
            return
        ;;

        "decrypt-str-by-vault" | "selector" ) 
            local lstr=$2
            test -z $lstr && read -p 'str to encrypt: ' lstr
            echo "$lstr" | openssl enc -base64 -aes-256-cbc -nosalt -pass pass:"$ANSIBLE_VAULT_PASSWORD_FILE_CONTENT" -d 2>>/dev/null
            return
        ;;



        "encrypt-file" | "selector" ) 
            local lfile=$2
            test -z $lfile && read -p 'file to encrypt: ' lfile
            local lpass=$3
            test -z $lpass && read -p 'password: ' lpass
            local tmp=$(mktemp)
            openssl enc -k "$lpass" -aes256 -base64 -e -in "$lfile" -out $tmp 2>>/dev/null
            cat $tmp && rm $tmp
            return
        ;;

        "encrypt-file-by-vault" | "selector" ) 
            local lfile=$2
            test -z $lfile && read -p 'file to encrypt: ' lfile
            local tmp=$(mktemp)
            openssl enc -k "$ANSIBLE_VAULT_PASSWORD_FILE_CONTENT" -aes256 -base64 -e -in "$lfile" -out $tmp 2>>/dev/null
            cat $tmp && rm $tmp
            return
        ;;

        "decrypt-file" | "selector" ) 
            local lfile=$2
            test -z $lfile && read -p 'file to encrypt: ' lfile
            local lpass=$3
            test -z $lpass && read -p 'password: ' lpass
            local tmp=$(mktemp)
            openssl enc -k "$lpass" -aes256 -base64 -d -in "$lfile" -out $tmp 2>>/dev/null
            cat $tmp && rm $tmp
            return
        ;;

        "decrypt-file-by-vault" | "selector" ) 
            local lfile=$2
            test -z $lfile && read -p 'file to encrypt: ' lfile
            local tmp=$(mktemp)
            openssl enc -k "$ANSIBLE_VAULT_PASSWORD_FILE_CONTENT" -aes256 -base64 -d -in "$lfile" -out $tmp 2>>/dev/null
            cat $tmp && rm $tmp
            return
        ;;



        "ansible" | "selector" ) flib-openssl ; return ;;
        "mtex" | "selector" ) flib-openssl ; return ;;
        "pipelines" | "selector" ) flib-openssl ; return ;;


        * ) 
            >&2 echo "wrong command:   $cmd"
            >&2 echo "available commands are:"
            type $FUNCNAME | grep selector | grep -v grep | sort | cut -d'"' -f2
        ;;

    esac

}

