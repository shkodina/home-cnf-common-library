export ANSIBLE_VAULT_PASSWORD_FILE=~/.ansible/vaults/deployer
export SELF_STORE_KEY_FILE=~/.etc/self-stor-key-file
export CLR_RED='\033[0;31m'
export CLR_GREEN='\033[0;32m'
export CLR_ORANGE='\033[0;33m'
export CLR_BLUE='\033[0;34m'
export CLR_PURP='\033[0;35m'
export CLR_CYAN='\033[0;36m'
export CLR_GREY='\033[0;37m'
export CLR_YELLOW='\033[1;33m'
export CLR_BLUE_LIGHT='\033[1;36m'
export CLR_WHITE='\033[1;37m'
export CLR_WHITE_CANCEL='\033[1;9m'
export CLR_WHITE_UNDER='\033[1;4m'
export CLR_NC='\033[0m' # No Color
 ######   ######## ########         ######## #### ######## ##       ########   ######
##    ##  ##          ##            ##        ##  ##       ##       ##     ## ##    ##
##        ##          ##            ##        ##  ##       ##       ##     ## ##
##   #### ######      ##    ####### ######    ##  ######   ##       ##     ##  ######
##    ##  ##          ##            ##        ##  ##       ##       ##     ##       ##
##    ##  ##          ##            ##        ##  ##       ##       ##     ## ##    ##
 ######   ########    ##            ##       #### ######## ######## ########   ######
alias f1='while read x1 last; do echo "$x1"; done'
alias f2='while read x1 x2 last; do echo "$x2"; done'
alias f3='while read x1 x2 x3 last; do echo "$x3"; done'
alias f4='while read x1 x2 x3 x4 last; do echo "$x4"; done'
alias f5='while read x1 x2 x3 x4 x5 last; do echo "$x5"; done'
alias f6='while read x1 x2 x3 x4 x5 x6 last; do echo "$x6"; done'
alias f7='while read x1 x2 x3 x4 x5 x6 x7 last; do echo "$x7"; done'
alias f8='while read x1 x2 x3 x4 x5 x6 x7 x8 last; do echo "$x8"; done'
alias f9='while read x1 x2 x3 x4 x5 x6 x7 x8 x9 last; do echo "$x9"; done'
alias body="tail -n +2"
# function ak() { awk "{print \$${1:-1}}"; }
 ######  ##    ##  ######  ######## ######## ##     ##
##    ##  ##  ##  ##    ##    ##    ##       ###   ###
##         ####   ##          ##    ##       #### ####
 ######     ##     ######     ##    ######   ## ### ##
      ##    ##          ##    ##    ##       ##     ##
##    ##    ##    ##    ##    ##    ##       ##     ##
 ######     ##     ######     ##    ######## ##     ##
alias clock='tty-clock -s -b -x -n -C 5 '
alias ll='ls -alhs --time-style="+%Y.%m.%d_%T"'
alias l='ls -l --time-style="+%Y.%m.%d_%T"'
alias l1='ls -1'
alias rm='rm -rf '
alias q='exit 0'
alias watch='watch '
alias tto='touch'
alias xa='xargs '
alias xargs='xargs '
alias d64='base64 -d'
alias reinit='fhomecnf-update-libs; source ~/.bashrc' # bash/personal-second/helpers.sh
alias rmlinks='find . -maxdepth 1 -type l | xargs rm'
alias off='sudo poweroff'
alias poweroff='sudo poweroff '
alias reboot='sudo reboot '
##     ##    ###    ######## ##     ##
###   ###   ## ##      ##    ##     ##
#### ####  ##   ##     ##    ##     ##
## ### ## ##     ##    ##    #########
##     ## #########    ##    ##     ##
##     ## ##     ##    ##    ##     ##
##     ## ##     ##    ##    ##     ##
alias summ='paste -sd+ | bc'
##    ## ########  ######## ##      ##
##   ##  ##     ## ##       ##  ##  ##
##  ##   ##     ## ##       ##  ##  ##
#####    ########  ######   ##  ##  ##
##  ##   ##   ##   ##       ##  ##  ##
##   ##  ##    ##  ##       ##  ##  ##
##    ## ##     ## ########  ###  ###
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
alias kube-capacity='kubectl resource-capacity'
# read  ga-vm-configs/krew
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --inline-info'
command -v kubectl &>/dev/null && source <(kubectl completion bash)
alias kc='kubectl'
complete -F __start_kubectl kc
command -v kubectl  &>/dev/null && complete -F __start_kubectl kc
function fkc-gen-full-config-from-splited-configs () {
    export KUBECONFIGS_DIR="~/.kube/splited_kubeconfigs/configs/"
    export KUBECONFIG=$(find ${KUBECONFIGS_DIR} -type f | tr '\n' ':')
    kubectl config view --flatten > ~/.kube/config
}
test -e /usr/bin/terraform && complete -C /usr/bin/terraform terraform || true
alias tf=terraform
alias tg=terragrunt
function aves () {
    test -e ./ansible.cfg && local avesid="--encrypt-vault-id deployer"
    local tmp_all=/tmp/$RANDOM$RANDOM$RANDOM$RANDOM$RANDOM$RANDOM$RANDOM
    ansible-vault encrypt_string $avesid "$1" 2>>/dev/null > $tmp_all
    head -n 1 $tmp_all 2>>/dev/null
    echo "  $(head -n 2 $tmp_all | tail -n 1 | tr -d ' ')" 2>>/dev/null
    echo "  $(tail -n +3 $tmp_all | tr -d "\ \n")" 2>>/dev/null
}
function avesd () {
    local tmp_all=/tmp/$RANDOM$RANDOM$RANDOM$RANDOM$RANDOM$RANDOM$RANDOM
    test -e ./ansible.cfg && local avesid="--encrypt-vault-id deployer"
    # echo 'var_from_file: !vault |' > $tmp_all
    # echo '  $ANSIBLE_VAULT;1.2;AES256;deployer' >> $tmp_all
    # echo "  $1" >> $tmp_all
    # ansible localhost -m ansible.builtin.debug -a var="var_from_file" -e "@$tmp_all" 2>>/dev/null | grep -A 9999 'var_from_file'
    echo '$ANSIBLE_VAULT;1.2;AES256;deployer' > $tmp_all
    echo "$1" >> $tmp_all
    ansible-vault decrypt $avesid $tmp_all
    cat $tmp_all
    rm $tmp_all
}
function avesdjs () {
    local tmp_all=/tmp/$RANDOM$RANDOM$RANDOM$RANDOM$RANDOM$RANDOM$RANDOM
    echo 'var_from_file: !vault |' > $tmp_all
    echo '  $ANSIBLE_VAULT;1.2;AES256;deployer' >> $tmp_all
    echo "  $1" >> $tmp_all
    ansible localhost -m ansible.builtin.debug -a var="var_from_file" -e "@$tmp_all" 2>>/dev/null | sed -e 's/localhost | SUCCESS =>//' | jq
    rm $tmp_all
}
function avesd-from-file-by-key () {
    local tmp_all=/tmp/$RANDOM$RANDOM$RANDOM$RANDOM$RANDOM$RANDOM$RANDOM
    test -e ./ansible.cfg && local avesid="--encrypt-vault-id deployer"
    yq -r "$2" $1 > $tmp_all
    ansible-vault decrypt $tmp_all && cat $tmp_all && rm $tmp_all
}
function avef () {
    local f=${1:?"Error: set up file name"}
    ansible-vault encrypt $f
}
function avefd () {
    local f=${1:?"Error: set up file name"}
    ansible-vault decrypt $f
}
function avefd-console () {
    local f=${1:?"Error: set up file name"}
    ansible-vault decrypt $f --output -
}
alias avefdc="avefd-console"
function fbanner0 () { echo -e "import art\nart.tprint('$@', font='banner')" | python ; }
function fbanner () { echo -e "import art\nart.tprint('$@', font='banner3')" | python ; }
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
function fssl-list-all-certs () {
    awk -v cmd='openssl x509 -noout -subject' '/BEGIN/{close(cmd)};{print | cmd}' < /etc/ssl/certs/ca-certificates.crt
}
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
            echo "$lstr" | openssl enc -base64 -aes-256-cbc -nosalt -pass pass:"$(cat ${ANSIBLE_VAULT_PASSWORD_FILE})" -e -A 2>>/dev/null
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
            echo "$lstr" | openssl enc -base64 -aes-256-cbc -nosalt -pass pass:"$(cat ${ANSIBLE_VAULT_PASSWORD_FILE})" -d 2>>/dev/null
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
            openssl enc -k "$(cat ${ANSIBLE_VAULT_PASSWORD_FILE})" -aes256 -base64 -e -in "$lfile" -out $tmp 2>>/dev/null
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
            openssl enc -k "$(cat ${ANSIBLE_VAULT_PASSWORD_FILE})" -aes256 -base64 -d -in "$lfile" -out $tmp 2>>/dev/null
            cat $tmp && rm $tmp
            return
        ;;
        "ansible" | "selector" ) flib-openssl ; return ;;
        "mtex" | "selector" ) flib-openssl ; return ;;
        "pipelines" | "selector" ) flib-openssl ; return ;;
        "list-all-certs" | "selector" ) fssl-list-all-certs ; return ;;
        * )
            >&2 echo "wrong command:   $cmd"
            >&2 echo "available commands are:"
            type $FUNCNAME | grep selector | grep -v grep | sort | cut -d'"' -f2
        ;;
    esac
}
function windnull () { $@ >>/dev/null 2>>/dev/null & }
function fwatch () {
  while true; do sleep 2; $@; done
}
function fsleep() {
    local secs=$1
    echo $1 | grep -q 's' && secs=$(echo $1 | tr -d 's')
    echo $1 | grep -q 'm' && secs=$(($(echo $1 | tr -d 'm') * 60))
    while [ $secs -gt 0 ]; do
        echo -ne ":$secs\033[0K\r"
        sleep 1
        : $((secs--))
    done
}
function rtmp () {  # FUNCTION RANDOM TMP
    local fname=${1}__$(fdate)--$(fdate | md5sum | cut -d' ' -f1)
    touch /tmp/$fname
    echo /tmp/$fname
}
function fcd () {
    cd $(dirname $(realpath $1))
}
function mkcdir ()
{
    local tdir=${1:-"/tmp/$(fddate)"}
    mkdir -p -- "$tdir"
       cd -P -- "$tdir"
}
function sudoaptupdateaptupgrade () {
    export DEBIAN_FRONTEND=noninteractive
    sudo apt update
    sudo apt upgrade -y
    sudo apt autoremove
    sudo apt upgrade -y |
        grep -q 'The following packages have been kept back:' && {
            echo 'run sudo apt-get --with-new-pkgs upgrade <list of packages kept back>'
        }
}
function ftool-list-all-colors (){
    for i in {1..50}; do echo -e "\033[0;${i}m SOME Color of 0 ${i} \033[0m" ; echo -e "\033[1;${i}m SOME Color of 1 ${i} \033[0m"; done;
    echo '\033[_;_m'
    set | grep -E "^CLR_.*"
}
alias fcolors=ftool-list-all-colors
function ffind () {
    find . -type f -iname "*$1*"
}
function fcnf-add-data-after-mask-from-file-in-file () {
    local mask=$1
    local data_file=$2
    local cnf_file=$3
    sed -i "/$mask/ r $data_file" $cnf_file
}
function fcnf-add-data-before-mask-from-file-in-file () {
    local mask=$1
    local data_file=$2
    local cnf_file=$3
    sed -i "/$mask/ e cat $data_file" $cnf_file
}
function ddate () {
    date +"%T_%d"/%m/%Y
}
function fdate () {
    date +"%T:%N_%d.%m.%Y"
}
function fddate () {
    date +"%H_%M_%S___%N___%d_%m_%Y"
}
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
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
function prepare_select_for_fzf () {
  echo $@ | cut -d ' ' -f 3- | tr '|' '\n' | tr ' ' '\n' | sed -e '/\[/d;/\]/d;s/(.*)//' | sort | uniq
}
function run_use_select_by_fzf () {
    $1 $(prepare_select_for_fzf $($1) | fzf --border --height=15%)
}
 ######   #######  ##     ## ##     ## #### ########
##    ## ##     ## ###   ### ###   ###  ##     ##
##       ##     ## #### #### #### ####  ##     ##
##       ##     ## ## ### ## ## ### ##  ##     ##
##       ##     ## ##     ## ##     ##  ##     ##
##    ## ##     ## ##     ## ##     ##  ##     ##
 ######   #######  ##     ## ##     ## ####    ##
function fgit-safe-commit () {
  git pull
  test "$1" == "" && git-commiter fast
  test "$1" == "." && test -z "$2" && git-commiter || git-commiter fast "$2"
  test -e ./pre-fgsc-hook.sh && ./pre-fgsc-hook.sh
  git commit -am "$GC_MESSAGE"
  git push
  echo -e  "${CLR_GREEN}$(git config --get remote.origin.url | tr ':' '/' | sed -e 's/git@/http:\/\//' | sed -e 's/http:\/\/ssh-/http:\/\//' | sed -e 's/\.git/\/-\/pipelines/')${CLR_NC}"
  echo -e "${CLR_YELLOW}$(git config --get remote.origin.url | tr ':' '/' | sed -e 's/git@/http:\/\//' | sed -e 's/http:\/\/ssh-/http:\/\//' | sed -e 's/\.git/\/-\/commits/'  )${CLR_NC}"
  test -z "${1}" && echo -e "Search commit message: ${CLR_GREEN}fast change commit $(date '+%Y.%m.%d %T')${CLR_NC}"
}
 ######   #######  ##     ## ##     ## #### ######## ######## ######## ########
##    ## ##     ## ###   ### ###   ###  ##     ##       ##    ##       ##     ##
##       ##     ## #### #### #### ####  ##     ##       ##    ##       ##     ##
##       ##     ## ## ### ## ## ### ##  ##     ##       ##    ######   ########
##       ##     ## ##     ## ##     ##  ##     ##       ##    ##       ##   ##
##    ## ##     ## ##     ## ##     ##  ##     ##       ##    ##       ##    ##
 ######   #######  ##     ## ##     ## ####    ##       ##    ######## ##     ##
function git-commiter () {
  local gc_types="\n
    build: Сборка проекта или изменения внешних зависимостей\n
    ci: Настройка CI и работа со скриптами\n
    chore: Правки от Девопсов\n
    docs: Обновление документации\n
    feat: Добавление нового функционала\n
    fix: Исправление ошибок\n
    perf: Изменения направленные на улучшение производительности\n
    refactor: Правки кода без исправления ошибок или добавления новых функций\n
    revert:	Откат на предыдущие коммиты\n
    style: Правки по кодстайлу (табы, отступы, точки, запятые и т.д.)\n
    test: Добавление или просто обработка тестов
  "
  local gc_scopes="\n
    pipe: пайплайн и иже с ним\n
    scripts: скрипты\n
    inventory: окружения\n
    roles: роли\n
    configs: настройки и конфигурации\n
    components: компаненты\n
    tutorial: маны\n
    custom: свой scope
  "
  if [ "$1" == "fast" ]
  then
    gc_type="chore"
    gc_scope="all"
    test "$2" == "" && gc_head="fast change commit $(date '+%Y.%m.%d %T')" || gc_head="$2"
    gc_body="$(git diff --name-only | tr '\n' '|')"
  else
    echo "Выбери тип коммита:"      && gc_type=$(echo -e ${gc_types}  | sort | fzf | cut -d: -f1 | tr -d ' ')
    echo "Выбери область коммита:"  && gc_scope_t=$(echo -e ${gc_scopes} | fzf | cut -d: -f1 | tr -d ' ')
    test "$gc_scope_t" == "custom" && read -p "Задай свой scope: " gc_scope || gc_scope=$gc_scope_t
    read -p "Дай краткий заголовок коммита: " gc_head
    read -p "Дай описание коммита (новая строка через |): " gc_body
    read -p "Добавь meta данные: " gc_meta
  fi
  local gc_message=$(echo -e "$gc_type($gc_scope): $gc_head\n\nbody:\n$(echo $gc_body | tr '|' \\n)$(test -z $gc_meta || echo -e '\n\n'meta: $gc_meta)" )
  echo -e "$gc_message"
  export GC_MESSAGE="$gc_message"
}
   ###    ##       ####    ###     ######  ########  ######
  ## ##   ##        ##    ## ##   ##    ## ##       ##    ##
 ##   ##  ##        ##   ##   ##  ##       ##       ##
##     ## ##        ##  ##     ##  ######  ######    ######
######### ##        ##  #########       ## ##             ##
##     ## ##        ##  ##     ## ##    ## ##       ##    ##
##     ## ######## #### ##     ##  ######  ########  ######
alias fgsc='fgit-safe-commit'
alias fgps='fgit pull && git submodule update --remote'
alias fgpr='fgit pull-rebase'
alias fgcnb='git checkout -b '
alias fgr='fgit reset'
alias fgb='fgit branch'
alias fgp='fgit pull'
alias fgp-all='fgit pull-all'
alias fgp-all-daemon='fgit pull-all-in-daemon'
alias fgurl='fgit get-base-url'
alias fgit-untracked='fgit untracked'
alias fgc='fgit checkout'
##     ## ######## ##       ########  ######## ########
##     ## ##       ##       ##     ## ##       ##     ##
##     ## ##       ##       ##     ## ##       ##     ##
######### ######   ##       ########  ######   ########
##     ## ##       ##       ##        ##       ##   ##
##     ## ##       ##       ##        ##       ##    ##
##     ## ######## ######## ##        ######## ##     ##
function fgit () {
    local sudo_prefix=
    test "$(whoami)" == "root" || sudo_prefix=sudo
    local cmd=$1
    test "$cmd" == "" && cmd=$(type $FUNCNAME | grep selector | grep -v grep | cut -d'"' -f2 | fzf)
    case $cmd in
#     #
#     # #####  #
#     # #    # #
#     # #    # #
#     # #####  #
#     # #   #  #
 #####  #    # ######
        "get-base-url" | "selector" )
            git config --get remote.origin.url |
            tr ':' '/' |
            sed -e 's/git@/http:\/\//' |
            sed -e 's/http:\/\/ssh-/http:\/\//'
            return ;;
        "url" | "selector" ) $FUNCNAME get-base-url ; return ;;
######
#     # #####    ##   #    #  ####  #    #
#     # #    #  #  #  ##   # #    # #    #
######  #    # #    # # #  # #      ######
#     # #####  ###### #  # # #      #    #
#     # #   #  #    # #   ## #    # #    #
######  #    # #    # #    #  ####  #    #
        "branch" | "selector" )
            git rev-parse HEAD > /dev/null 2>&1 || return
            git branch -a --color=always --sort=-committerdate |
                grep -v HEAD |
                fzf --height 50% --ansi --no-multi --preview-window right:65% \
                    --preview 'git log -n 50 --color=always --date=short --pretty="format:%C(auto)%cd %h%d %s" $(sed "s/.* //" <<< {})' | sed "s/.* //"
            return ;;
        "reset" | "selector" ) git reset --hard HEAD ; return ;;
######          #####
#     # ###### #     # #       ####  #    # ######
#     # #      #       #      #    # ##   # #
######  #####  #       #      #    # # #  # #####
#   #   #      #       #      #    # #  # # #
#    #  #      #     # #      #    # #   ## #
#     # ######  #####  ######  ####  #    # ######
        "re-clone" | "selector" )
            local dir=${PWD##*/}  #  name of current dir
            local gurl="$(git config --get remote.origin.url)"
            cd ..
            sudo rm -rf "$dir"
            git clone "$gurl" "$dir"
            cd "$dir"
            return ;;
  #     #
#     # #    # ##### #####    ##    ####  #    #
#     # ##   #   #   #    #  #  #  #    # #   #
#     # # #  #   #   #    # #    # #      ####
#     # #  # #   #   #####  ###### #      #  #
#     # #   ##   #   #   #  #    # #    # #   #
 #####  #    #   #   #    # #    #  ####  #    #
        "untracked" | "selector" ) git ls-files --others --exclude-standard ; return ;;
        "un" | "selector" ) $FUNCNAME  untracked ; return ;;
        "un-add" | "selector" ) $FUNCNAME  untracked | xargs git add ; return ;;
 #####                              #######
#     # #    # ######  ####  #    # #     # #    # #####
#       #    # #      #    # #   #  #     # #    #   #
#       ###### #####  #      ####   #     # #    #   #
#       #    # #      #      #  #   #     # #    #   #
#     # #    # #      #    # #   #  #     # #    #   #
 #####  #    # ######  ####  #    # #######  ####    #
        "checkout" | "selector" )
            git rev-parse HEAD > /dev/null 2>&1 || return
            local branch=$($FUNCNAME branch)
            test "$branch" = "" && ( echo "No branch selected." ; return ; )
            if [[ "$branch" = 'remotes/'* ]]; then
                git checkout --track $branch
            else
                git checkout $branch;
            fi
            return ;;
#     #
##   ## ###### #####   ####  ######
# # # # #      #    # #    # #
#  #  # #####  #    # #      #####
#     # #      #####  #  ### #
#     # #      #   #  #    # #
#     # ###### #    #  ####  ######
        "merge-from" | "selector" )
            local br=$($FUNCNAME branch)
            local cbr=$(git branch --show-current)
            git checkout $br
            git pull
            git checkout $cbr
            git merge $br
            return ;;
######
#     # #    # #      #
#     # #    # #      #
######  #    # #      #
#       #    # #      #
#       #    # #      #
#        ####  ###### ######
        "pull" | "selector" )
            git pull
            git submodule update --init --recursive
            return ;;
        "pull-rebase" | "selector" ) git pull --rebase ; return ;;
        "pull-all" | "selector" )
            find . -type d -name ".git" | while read d;
              do
                f_log_info "$d";
                git -C ${d%/*}/ pull;
              done
            return ;;
        "pull-all-in-daemon" | "selector" )
            find . -type d -name ".git" | while read d;
              do
                f_log_info "$d";
                git -C ${d%/*}/ pull &
              done
            return ;;
        * )
            >&2 echo "wrong command:   $cmd"
            >&2 echo "available commands are:"
            type $FUNCNAME | grep selector | grep -v grep | cut -d'"' -f2
            return
        ;;
    esac
}
alias fgg=fgit
 ######   ######## ##    ##       ##     ## ######## ########
##    ##  ##       ###   ##       ##     ## ##       ##     ##
##        ##       ####  ##       ##     ## ##       ##     ##
##   #### ######   ## ## ##       ##     ## ######   ########
##    ##  ##       ##  ####        ##   ##  ##       ##   ##
##    ##  ##       ##   ###         ## ##   ##       ##    ##
 ######   ######## ##    ##          ###    ######## ##     ##
function f_lib_generate_version () {
    # если откудато уже пришла версия то сохраним ее
    local PREDEFINED_VERSION=$VERSION
    git describe --tags --always --abbrev=8
    test $(git describe --tags --always --abbrev=8 | sed -E 's/^v//g' | sed -E 's/^\.//g' | grep -c '\.') -gt 0 \
            && VERSION=$(git describe --tags --always --abbrev=8 | sed -E 's/^v//g' | sed -E 's/^\.//g' | tr '()' '.' | sed -E "s/\.+$//" ) \
            || VERSION=0.0.1-$(git log | grep -c commit)-$(git describe --tags --always --abbrev=8 | tr '()' '.' | sed -E "s/\.+$//")
    test $VERSION_PREFIX && VERSION=$VERSION_PREFIX-$VERSION
    test $VERSION_SUFFIX && VERSION=$VERSION-${VERSION_SUFFIX//:/-}
    echo "$CI_BUILD_REF_NAME" | grep -q debug && VERSION=$VERSION-debug || true
    # тут если версия из артефатов или первого объеявления не пуста и не совпала
    test "$PREDEFINED_VERSION" != "" && \
        test "$PREDEFINED_VERSION" != "$VERSION" && \
            f_log_info "PREDEFINED_VERSION: $PREDEFINED_VERSION  DIFF FROM VERSION: $VERSION" && \
                export VERSION=$PREDEFINED_VERSION
    # тут если версия юзерская и не совпала, то сделаем мегакостылем ее главной
    test "$USER_DEFINED_VERSION" != "" ] && \
        test "$USER_DEFINED_VERSION" != "$VERSION" && \
            f_log_info "USER_DEFINED_VERSION: $USER_DEFINED_VERSION  DIFF FROM VERSION: $VERSION" && \
                export VERSION=$USER_DEFINED_VERSION
    export VERSION=$VERSION
    # echo VERSION="${VERSION}" > $CI_PROJECT_DIR/variables.env
}
command -v helm  &>/dev/null && complete -o default -F __start_helm helm
command -v helm  &>/dev/null && source <(helm completion bash)
function fhelm-roll-back-chart-by-grep-from-history () {
    APP=${1:?"Error. You must supply helm release name."}
    GREP_STR=${2:?"Error. You must supply a grep string to select revision."}
    helm history ${APP} | grep -v "${GREP_STR}" | while read rrev stub; do echo $rrev $stub; echo $rrev; let rrev--; echo $rrev; helm rollback ${APP} $rrev; done
}
function fhelm-roll-back-last () {
    APP=${1:?"Error. You must supply helm release name."}
    helm history ${APP} | tail -n 1 | while read rrev stub; do echo $rrev $stub; echo $rrev; let rrev--; echo $rrev; helm rollback ${APP} $rrev; done
}
function fhelm () {
    helm $@ $(  helm list -a |
                fzf |
                while read x1 stuff; do echo $x1; done
            )
}
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
alias fu=futils##     ## ######## ##       ########  ######## ########
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
##        #######   ######
##       ##     ## ##    ##
##       ##     ## ##
##       ##     ## ##   ####
##       ##     ## ##    ##
##       ##     ## ##    ##
########  #######   ######
function fglogg () {
  local t=$(echo -e "po\ndeploy\nsts\nds" | fzf)
  kubectl logs $(kubectl get -o name $t| fzf)
}
function fglogff () {
  local t=$(echo -e "po\ndeploy\nsts\nds" | fzf)
  kubectl logs $(kubectl get -o name $t| fzf) --follow
}
function fglog () {
  test -z $1 \
    && kubectl logs $(fget pods) \
    || kubectl logs $1
}
function fgetcontainerfrompod () {
  fgy po $1 | yq '.spec.containers[].name'
  fgy po $1 | yq '.spec.initContainers[].name'
}
function fglog-container () {
  local pp=$(fget pods)
  kubectl logs $pp -c $(fgetcontainerfrompod $pp | fzf)
}
function fglog-follow () {
  test -z $1 \
    && kubectl logs $(fget pods) --follow \
    || kubectl logs $1 --follow
}
alias fglogf=fglog-follow
alias nohealthchecks='grep -v -E "/metrics|/readyz|/livez"'
function fglog-previous () {
  test -z $1 \
    && kubectl logs $(fget pods) --previous \
    || kubectl logs $1 --previous
}
 ######  ########  ######  ########  ######## ########
##    ## ##       ##    ## ##     ## ##          ##
##       ##       ##       ##     ## ##          ##
 ######  ######   ##       ########  ######      ##
      ## ##       ##       ##   ##   ##          ##
##    ## ##       ##    ## ##    ##  ##          ##
 ######  ########  ######  ##     ## ########    ##
function fgetsecretdata () {
  kubectl get secret -oyaml $(kubectl get secret | grep -v 'helm.sh/release' |
    tail -n +2 |
      while read ff1 ttail; do echo $ff1; done | fzf) |
        yq '.data' |
          while read k v; do echo $k $(echo $v | base64 -d); done
}
function fgetsecretdata-from-tls () {
  kubectl get secrets |
    grep kubernetes.io/tls |
      while read n stub; do echo $n; done |
        fzf |
          xargs kubectl get secret -oyaml |
            yq '.data."tls.crt"' |
              base64 -d |
                openssl x509 -noout -text
}
function fget-external-secrets () {
cat << EOF
  kubectl get  secretstore.external-secrets.io
  kubectl get  clustersecretstore.external-secrets.io
  kubectl get  externalsecret.external-secrets.io
  fgy  secretstore.external-secrets.io
  fgy  clustersecretstore.external-secrets.io
  fgy  externalsecret.external-secrets.io
EOF
}
# alias  es=externalsecret.external-secrets.io
# alias  ss=secretstore.external-secrets.io
# alias css=clustersecretstore.external-secrets.io
 ######  ##     ##       #### ##    ## ########  #######
##    ## ###   ###        ##  ###   ## ##       ##     ##
##       #### ####        ##  ####  ## ##       ##     ##
##       ## ### ##        ##  ## ## ## ######   ##     ##
##       ##     ##        ##  ##  #### ##       ##     ##
##    ## ##     ##        ##  ##   ### ##       ##     ##
 ######  ##     ##       #### ##    ## ##        #######
function fginfo () {
  kubectl get cm -oname -l cnf-type=info |
  cut -d/ -f2 |
  sed -e "s/-deploy-info//g" |
  fzf -m |
  while read app;
  do
    kubectl get cm -oyaml ${app}-deploy-info |
    yq .data |
    grep -i -E "URL|gitlab_cnf_link|CICD_ANSIBLE_GITLAB_SVC_CNF_LINK|argocd_values" |
    grep 'https://' |
    cut -d: -f2- |
    sort -u
  done
}
function fginfo-full () {
  kubectl get cm -oname -l cnf-type=info |
  cut -d/ -f2 |
  sed -e "s/-deploy-info//g" |
  fzf |
  xargs -I {} kubectl get cm -oyaml {}-deploy-info |
  yq .data
}
alias fginfof=fginfo-full ######   ######## ########
##    ##  ##          ##
##        ##          ##
##   #### ######      ##
##    ##  ##          ##
##    ##  ##          ##
 ######   ########    ##
function fget-src () {
    kubectl api-resources | fzf | cut -d' ' -f1
}
function fget_helper () {
  test -z $1 \
  && kubectl get $(fget-src) --no-headers \
  || kubectl get $1 --no-headers
}
function fget () {
  local list=$(fget_helper $1)
  echo -e "$list" | fzf | f1
}
function fgetm () {
  local list=$(fget_helper $1)
  echo -e "$list" | fzf -m | f1
}
function fgy () {  # $1 = k8s source name  $2 = source name
  local src_name=${1:-$(fget-src)}
	local obj_name=${2:-$(fgetm $src_name)}
  kubectl get $src_name $obj_name -oyaml
}	
function fgy-meta(){
  fgy $1 $2 | yq -r .metadata
}
######## ##     ## ########  ######
##        ##   ##  ##       ##    ##
##         ## ##   ##       ##
######      ###    ######   ##
##         ## ##   ##       ##
##        ##   ##  ##       ##    ##
######## ##     ## ########  ######
function fexe () {
    kubectl exec $(kubectl get -oname po | fzf) -- $@
}
function fexe-in-pod-by-mask-podname () {
   local podmask=$1
   shift
   for p in $(kubectl get -oname po | grep $podmask )
   do
     kubectl exec $p -- $@
   done
}
########  ########  ######   ######
##     ## ##       ##    ## ##    ##
##     ## ##       ##       ##
##     ## ######    ######  ##
##     ## ##             ## ##
##     ## ##       ##    ## ##    ##
########  ########  ######   ######
function fdesc () {  # $1 = k8s source name  $2 = pod name
        local src_name=$1
        test -z $src_name && src_name=$(kubectl api-resources | fzf | cut -d' ' -f1)
	test -z $2 && for x in $(fgetm $src_name) ; do  kubectl describe $src_name $x ; done
	test -z $2 || { shift ; for x in $@ ; do  kubectl describe $src_name $x ; done ;}
}
########  ######## ##
##     ## ##       ##
##     ## ##       ##
##     ## ######   ##
##     ## ##       ##
##     ## ##       ##
########  ######## ########
function fdel () {  # $1 = k8s source name  $2 = pod name
  local src_name=$1
  test -z $src_name && src_name=$(kubectl api-resources | fzf | cut -d' ' -f1)
  test -z $2 && kubectl delete $src_name $(fgetm $src_name)
  test -z $2 || kubectl delete $src_name $2
}
function fdel-A () {  # $1 = k8s source name
  local src_name=$1
  test -z $src_name && src_name=$(kubectl api-resources | fzf | cut -d' ' -f1)
  kubectl get $src_name -A | fzf -m | while read ns src stuff;
  do
    >&2 echo "kubectl -n $ns delete $src_name $src"
    kubectl -n $ns delete $src_name $src
  done
}
######## ########  #### ########
##       ##     ##  ##     ##
##       ##     ##  ##     ##
######   ##     ##  ##     ##
##       ##     ##  ##     ##
##       ##     ##  ##     ##
######## ########  ####    ##
function fedit () {  # $1 = k8s source name  $2 = source name
        local src_name=$1
        test -z $src_name && src_name=$(kubectl api-resources | fzf | cut -d' ' -f1)
        test -z $2 \
                && kubectl edit $src_name $(fget $src_name) \
                || kubectl edit $src_name $2
}
######## ######## ########
##       ##       ##
##       ##       ##
######   ######   ######
##       ##       ##
##       ##       ##
##       ######## ########
function fee () {
  local shellname=${1:-"bash"}
  local po=$(fget pod)
  local tpo=$(mktemp)
  kubectl get po $po -o yaml > $tpo
  yq '.spec.containers[].name' $tpo | grep -q main \
    && kubectl exec --stdin --tty $po -c main -- $shellname \
    || kubectl exec --stdin --tty $po -- $shellname
}
function fee-in-container () {
  if [ -z $1 ]  #  no pod no container
  then
    local pp=$(fget pods)
    local cc=$(fgetcontainerfrompod $pp | fzf)
  else  #  selected container
    local cc=$1
    test -z $2 && local pp=$(fget pods) || pp=$2
  fi
  kubectl exec --stdin --tty $pp -c $cc -- /bin/sh
}
alias fee-c=fee-c
   ###    ##       ####    ###     ######  ########  ######
  ## ##   ##        ##    ## ##   ##    ## ##       ##    ##
 ##   ##  ##        ##   ##   ##  ##       ##       ##
##     ## ##        ##  ##     ##  ######  ######    ######
######### ##        ##  #########       ## ##             ##
##     ## ##        ##  ##     ## ##    ## ##       ##    ##
##     ## ######## #### ##     ##  ######  ########  ######
alias fkc-kill='fkill'
alias fkc-url='tail -n +2 | grep -o -E "nginx.* +" | while read ss uri tt; do for iii in $(echo $uri | tr "," "\ "); do printf "%-60s %s\n" $ii https://$iii ; done ; done'
alias url='fkc-url'
alias kc='kubectl '
alias ke='kubie'
alias g='kc get --chunk-size=0'
alias gwide='kc get -owide --chunk-size=0 '
alias gname='kc get -oname --chunk-size=0 '
alias gyaml='kc get -oyaml --chunk-size=0 '
alias gjson='kc get -ojson --chunk-size=0 '
alias k9s='docker run --rm -it -v ~/.kube/config:/root/.kube/config quay.io/derailed/k9s'
alias grlb='kubectl get rolebindings'
alias xkcd='xargs kubectl delete'
alias xkcgy='xargs kubectl get -o yaml --chunk-size=0'
##    ## ######## ##    ##
##   ##  ##       ###   ##
##  ##   ##       ####  ##
#####    ######   ## ## ##
##  ##   ##       ##  ####
##   ##  ##       ##   ###
##    ## ######## ##    ##
function ken () {
  local nslist=$(kubectl get ns -oname | cut -d'/' -f2- | grep ".*$1.*")
  test "$(echo $nslist | tr ' ' '\n' | wc -l)" -gt "1" && {
    kubie ns $(echo $nslist | tr ' ' '\n' | fzf)
  } || {
    kubie ns ${nslist}
  }
}
########  #######  ##    ## ######## ##    ##
   ##    ##     ## ##   ##  ##       ###   ##
   ##    ##     ## ##  ##   ##       ####  ##
   ##    ##     ## #####    ######   ## ## ##
   ##    ##     ## ##  ##   ##       ##  ####
   ##    ##     ## ##   ##  ##       ##   ###
   ##     #######  ##    ## ######## ##    ##
function fkc-token-review () {
  local ktoken=${1:?"Error. You must supply token value."}
  tmp=/tmp/$RANDOM$RANDOM$RANDOM$RANDOM$RANDOM$RANDOM$RANDOM$RANDOM.yaml
cat > $tmp << EOF
kind: TokenReview
apiVersion: authentication.k8s.io/v1
metadata:
  name: test
spec:
  token: $ktoken
EOF
  echo kubectl apply -o yaml -f $tmp
  kubectl apply -o yaml -f $tmp
}
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
        local src_count=${1:?"Error. You must supply new count in FIRST parameter."}
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
function switch_kubie_ctx_ns () {
    echo kubie ctx -n $2 $1
    kubie ctx -n $2 $1
}
function fkn () {
  local ctx=
  test $(kubectl config get-contexts -oname | grep -E ".*${2}.*" | wc -l) -gt 1 \
    && ctx=$(kubectl config get-contexts -oname | grep -E ".*${2}.*" | fzf ) \
    || ctx=$(kubectl config get-contexts -oname | grep -E ".*${2}.*" )
  # local filter=${1:-"*"}
  local nslist=$(kubectl --context ${ctx} get ns -oname | cut -d'/' -f2 | grep -E ".*${1}.*")
  test "$(echo $nslist | tr ' ' '\n' | wc -l)" -gt "1" && {
    switch_kubie_ctx_ns ${ctx} $(echo $nslist | tr ' ' '\n' | fzf)
  } || {
    switch_kubie_ctx_ns ${ctx} ${nslist}
  }
}
 ######  ##     ##  ######
##    ## ##     ## ##    ##
##       ##     ## ##
 ######  ##     ## ##
      ##  ##   ##  ##
##    ##   ## ##   ##    ##
 ######     ###     ######
function fkc-svc-kill () {
  local ss_svc=${1-$(fget svc)}
  kubectl patch service $ss_svc -p "{\"metadata\":{\"finalizers\":null}}"
  kubectl delete service $ss_svc
}
alias fkc-kill-svc=fkc-svc-kill
##    ##  ######
###   ## ##    ##
####  ## ##
## ## ##  ######
##  ####       ##
##   ### ##    ##
##    ##  ######
function fkc-ns-kill () {  #  $1 = ns_name
  local ns_name=${1-$(fget ns)}
  kubectl proxy &
  kubectl get namespace $ns_name -o json |jq '.spec = {"finalizers":[]}' >/tmp/temp.json
  curl -k -H "Content-Type: application/json" \
    -X PUT \
    --data-binary @/tmp/temp.json \
    127.0.0.1:8001/api/v1/namespaces/$ns_name/finalize
  rm -f /tmp/temp.json
  ps ax | grep 'kubectl proxy' | grep -v grep | first | xargs kill -9
}
alias fkc-kill-ns=fkc-ns-kill
########   #######  ########   ######
##     ## ##     ## ##     ## ##    ##
##     ## ##     ## ##     ## ##
########  ##     ## ##     ##  ######
##        ##     ## ##     ##       ##
##        ##     ## ##     ## ##    ##
##         #######  ########   ######
function fkc-pods-with-limits () {
  local ns='NAMESPACE:.metadata.namespace'
  local pod="POD:.metadata.name"
  local container='CONTAINER:.spec.containers[*].name'
  local resource_req_mem='MEM_REQ:.spec.containers[*].resources.requests.memory'
  local resource_lim_mem='MEM_LIM:.spec.containers[*].resources.limits.memory'
  local resource_req_cpu='CPU_REQ:.spec.containers[*].resources.requests.cpu'
  local resource_lim_cpu='CPU_LIM:.spec.containers[*].resources.limits.cpu'
  kubectl get pod --chunk-size=0 -A -o custom-columns="$ns,$pod,$container,$resource_req_mem,$resource_lim_mem,$resource_req_cpu,$resource_lim_cpu"
}
function fkill () {  # $1 = pod name
        local name=$1
        [ -z $name ] && { name=$(kubectl get pods | tail -n +2 | fzf -m | f1) ;  kubectl delete pod --grace-period=0 --force $name ; } \
                     || for pp in $* ; do kubectl delete pod --grace-period=0 --force $pp ; done
}
function fkc-pods-cleanup () {
  kubectl get po --chunk-size=0 -A |
  grep -E "Completed|Unknown" |
  while read ns po xxx;
  do
    kubectl -n $ns delete po $po;
  done
}
function fkc-cp-to-pod () {
  local x=${1:?"Error. You must supply full path to file for copy"}
  kubectl cp $1 $(kubectl get po -oname | cut -d'/' -f2 | fzf):$1
}
function fkc-pods-port-proxy () {
  local pod=$(kubectl get po -oname | fzf)
  read -p 'set POD port: ' podport
  read -p 'set local port: ' lport
  echo kubectl port-forward $pod $lport:$podport
  kubectl port-forward $pod $lport:$podport
}
function fkc-pod-debug () {
    local dimages="
    harbor.tech.mvideo.ru/mvideoru/quasar/devops/maintenance/toolbox/master/quasar-toolbox-u22-full:latest
    harbor.tech.mvideo.ru/mvideoru/quasar/devops/maintenance/toolbox/master/quasar-toolbox-kafka-tools:latest
    harbor.tech.mvideo.ru/mvideoru/quasar/devops/maintenance/toolbox/master/quasar-toolbox-kafka-tools:0.0.1-101-8772e0de
    nicolaka/netshoot
    "
    local lpod=$(kubectl get po -oname | cut -d/ -f2 | fzf)
    local lconname=$(kubectl get po -oyaml $lpod | yq -r .spec.containers[].name | fzf)
    local udimage=$(echo $dimages | tr ' ' '\n' | fzf)
    kubectl debug -it $lpod --image=$udimage --target=$lconname
}
##    ##  #######  ########  ########  ######
###   ## ##     ## ##     ## ##       ##    ##
####  ## ##     ## ##     ## ##       ##
## ## ## ##     ## ##     ## ######    ######
##  #### ##     ## ##     ## ##             ##
##   ### ##     ## ##     ## ##       ##    ##
##    ##  #######  ########  ########  ######
function fkc-nodes-non-terminated-pods () {
  local maxl=$(for n in $(kc get no -oname); do echo $n | wc -c; done | sort -u | tail -n 1)
  printf "%-${maxl}s %-15s %s\n" NodeName PodCapacity PodNoneTerminatedState
  for n in $(kubectl get no -oname)
  do
    local nn=$(kubectl describe $n)
    local nname=$(echo -e "$nn" | grep -E "^Name:" | cut -d: -f2)
    local ncpod=$(echo -e "$nn" | grep -A 7 -E "^Capacity:" | grep pods: | cut -d: -f2)
    local nwpod=$(echo -e "$nn" | grep -E "^Non-terminated Pods:" | cut -d: -f2 | tr -c -d "[0-9]")
    printf "%-${maxl}s %-15s %s\n" $nname $ncpod $nwpod
  done
}
function fkc-node-ssh-to () {
  # local fuser="piper_al"
  test -z $KUBIE_ACTIVE && echo "NO KUBIE. EXIT"
  test -z $KUBIE_ACTIVE && return
  # local fnode=$(kc get nodes -oname | fzf)
  # local fip=$(kc get $fnode -oyaml  | yq -r .status.addresses[].address | grep -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')
  # echo "ssh ${fuser}@${fip}"
  # echo "Use passwd: ${GA_PIPER_AL_PWD}"
  # ssh ${fuser}@${fip}
  ssh $(kc get nodes -oname | fzf | xa kc get -oyaml | yq -r .status.addresses[].address | grep -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')
}
function fkc-node-debug () {
    local dimages="
    ubuntu:22.04
    nicolaka/netshoot
    harbor.yc.lime-shop.com/lime-devops/base-lime-devops-toolbox-helpfull-images/main/xtoolbox-6-worker:latest
    "
    local nnode=$(kubectl get node -oname | fzf )
    local udimage=$(echo $dimages | tr ' ' '\n' | fzf)
    kubectl debug $nnode -it --image=$udimage
    kubectl get po -oname | grep node-debugger | grep ${nnode//node\/} | xargs kubectl delete
}
function fkc-node-cordone () { kubectl cordon $(fget node) ; }
function fkc-node-uncordone () { kubectl uncordon $(fget node) ; }
function fkc-node-drain () {
  local lnode=$(fget node)
  local keys=$(echo -e " \n --ignore-daemonsets \n --delete-emptydir-data " | fzf -m)
  echo kubectl drain $keys $lnode
  kubectl drain $keys $lnode
}
function fkc-node-prepare-tg-apply-worker () {
  local i=0
  kubectl get no | grep worker | while read w s; do echo $w; done | sort | while read w
  do
    cat << EOF
kubectl cordon $w;
sleep 10;
timeout -s SIGKILL 600 kubectl drain --ignore-daemonsets --delete-emptydir-data $w;
sleep 60;
terragrunt apply --auto-approve --target="yandex_compute_instance.instance[$i]";
sleep 600;
kubectl uncordon $w;
EOF
  ((i++))
  done
}
function fkc-node-shell () {
  kubectl node-shell $(kubectl get no -oname | cut -d / -f2 | fzf)
}
########  ##     ##          ########  ##     ##  ######
##     ## ##     ##          ##     ## ##     ## ##    ##
##     ## ##     ##          ##     ## ##     ## ##
########  ##     ##          ########  ##     ## ##
##         ##   ##           ##         ##   ##  ##
##          ## ##            ##          ## ##   ##    ##
##           ###             ##           ###     ######
function fkc-pv-force-delete () {
  test "$1" == "" && kubectl patch pv $(kubectl get pv | grep Terminating | fzf | cut -d' ' -f1) -p '{"metadata": {"finalizers": null}}'
  test "$1" == "" || kubectl patch pv "$1" -p '{"metadata": {"finalizers": null}}'
}
function fkc-pvc-force-delete () {
  test "$1" == "" && kubectl patch pvc $(kubectl get pvc | grep Terminating | fzf | cut -d' ' -f1) -p '{"metadata": {"finalizers": null}}'
  test "$1" == "" || kubectl patch pvc "$1" -p '{"metadata": {"finalizers": null}}'
}
function fkc-pvc-full-delete () {
  local lpvcs=$1;
  test "${lpvcs}" == "" && lpvcs=$(kubectl get pvc | fzf -m | cut -d' ' -f1)
  for lpvc in ${lpvcs}
  do
    local lpv=$(kubectl get pvc -oyaml ${lpvc} | yq '.spec.volumeName')
    echo kubectl delete pvc ${lpvc}
    kubectl delete pvc ${lpvc}
    echo kubectl delete pv ${lpv}
    kubectl delete pv ${lpv}
  done
  return 0
}
function f_log_title () {
    echo ""
    echo -e "${CLR_GREEN}#################################################"
    echo -e "${CLR_GREEN}##"
    echo -e "${CLR_GREEN}##  $@"
    echo -e "${CLR_GREEN}##"
    echo -e "${CLR_GREEN}#################################################"
    echo -e "${CLR_NC}"
}
alias flog_title=f_log_title
function f_log_error () {
    echo ""
    echo -e "${CLR_RED}#################################################"
    echo -e "${CLR_RED}##  $@"
    echo -e "${CLR_RED}#################################################"
    echo -e "${CLR_NC}"
} >&2
alias flog_error=f_log_error
function f_log_warn () {
    echo -e "${CLR_YELLOW}##  $@"
    echo -e "${CLR_NC}"
}
alias flog_warn=f_log_warn
function f_log_info () {
    echo -e "${CLR_GREEN}##  $@"
    echo -e "${CLR_NC}"
}
alias flog_info=f_log_info
function f_log_timestamp () { date +"%T %d"/%m/%Y ;}
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
function fredis-redis-scan-role-by-base-count () {  #  $1 = host_base  $2 = start  $3 = stop
    while true
    do
        echo
        sleep 2
        for i in $(seq $2 $3)
        do
            echo $1$i $(redis-cli -h $1$i -p 6379 info Replication | grep role)
        done
    done
}
function fredis-redis-scan-role-by-host-list () {  #  $@ = hosts splited by space
    while true
    do
        echo
        sleep 2
        for i in $@
        do
            echo $1$i $(redis-cli -h $i -p 6379 info Replication | grep role)
        done
    done
}
function fredis-redis-cmd-by-base-count () {  #  $1 = host_base  $2 = start  $3 = stop  $4 = cmd
    while true
    do
        echo
        sleep 2
        for i in $(seq $2 $3)
        do
            echo $1$i
            redis-cli -h $1$i -p 6379 $4
        done
    done
}
function fredis-sentinel-scan-roles-by-base-count () {  #  $1 = host_base  $2 = start  $3 = stop
    while true
    do
        echo
        sleep 2
        for i in $(seq $2 $3)
        do
            echo $1$i master: $(redis-cli -h $1$i -p 26379 sentinel master mymaster | grep -A 1 ip | grep -v ip )
            echo $1$i slaves: $(redis-cli -h $1$i -p 26379 sentinel slaves mymaster | grep -A 1 ip | grep -v ip )
        done
    done
}
function fredis-sentinel-scan-roles-by-host-list () {  #  $@ = hosts splited by space
    while true
    do
        echo
        sleep 2
        for i in $@
        do
            echo $1$i master: $(redis-cli -h $i -p 26379 sentinel master mymaster | grep -A 1 ip | grep -v ip )
            echo $1$i slaves: $(redis-cli -h $i -p 26379 sentinel slaves mymaster | grep -A 1 ip | grep -v ip )
        done
    done
}
function rpwd1 () { echo ; date | md5sum | cut -d' ' -f1; echo ; }
function rpwd2 () { echo ; cat /dev/random | fold -w30 | head -n1 | base64 ; echo ; }
function rpwd3 () { echo ; cat /dev/random | fold -w30 | head -n1 | base64 | tr -cd '[:alnum:]' ; echo ; }
function rpwd4 () { echo ; openssl rand -base64 32 ; echo; }
# function fhide-note-message() {
#     local pass=$(rpwd3 | grep -v -E "^$" | head -n 1)
#     echo $pass > pass.txt
#     local message=$(echo "$1" | gpg -a --batch --passphrase-file pass.txt -c  --cipher-algo AES256 2>>/dev/null | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n/\\n/g');
#     local url='https://hidenote.goldapple.ru/'
# local payload=$(cat << EOF
# {
#   "message": "${message}",
#   "expiration": 604800 ,
#   "one_time": true
# }
# EOF
# )
#     local curl_res=$(curl -s -L -XPOST  ${url}/secret -H 'Content-Type: application/json' -d "${payload}")
#     # echo $curl_res | jq
#     local secret_id=$(echo $curl_res |  jq -r .message)
#     echo ${url}/#/s/$secret_id/$pass
#     rm -rf pass.txt
# }
# fmtex-hide-yopass-message now in https://gitlab.tech.mvideo.ru/mvideoru/quasar/devops/library/bash/-/blob/master/lib-files/mtex---rpwd.sh?ref_type=heads
# function fmtex-hide-yopass-message() {
#     test -e $HOME_CNF_ETC_DIR/etc/py/yopass_api_mtex.py || return
#     $HOME_CNF_ETC_DIR/etc/py/yopass_api_mtex.py -d "$1"
# }
function rpwd () {
    local p1=$(rpwd1 | grep -v -E "^$" | head -n 1); echo $p1
    [[ $(type -t fmtex-hide-yopass-message) == function ]] && fmtex-hide-yopass-message "$p1"
    [[ $(type -t aves) == function ]] && aves "$p1"
    echo -e "\n\n"
    # fhide-note-message "$p1"
    local p2=$(rpwd2 | grep -v -E "^$" | head -n 1); echo $p2
    [[ $(type -t fmtex-hide-yopass-message) == function ]] && fmtex-hide-yopass-message "$p2"
    [[ $(type -t aves) == function ]] && aves "$p2"
    echo -e "\n\n"
    # fhide-note-message "$p2"
    local p3=$(rpwd3 | grep -v -E "^$" | head -n 1); echo $p3
    [[ $(type -t fmtex-hide-yopass-message) == function ]] && fmtex-hide-yopass-message "$p3"
    [[ $(type -t aves) == function ]] && aves "$p3"
    echo -e "\n\n"
    # fhide-note-message "$p3"
    local p4=$(rpwd4 | grep -v -E "^$" | head -n 1); echo $p4
    [[ $(type -t fmtex-hide-yopass-message) == function ]] && fmtex-hide-yopass-message "$p4"
    [[ $(type -t aves) == function ]] && aves "$p4"
    echo -e "\n\n"
    # fhide-note-message "$p4"
}
function sshtmp () {
    ssh -o "ConnectTimeout 3" \
        -o "StrictHostKeyChecking no" \
        -o "UserKnownHostsFile /dev/null" \
            "$@"
}
function fssh-key-gen () {
    local folder="/tmp/$(date '+%s')"
    mkdir -p $folder
    ssh-keygen -t rsa -b 1024 -N "" -f $folder/id_rsa -q
    find $folder -type f
}
function f_telegram_notice_bot() {
    local x=
    local usege="Usage: $FUNCNAME  <token>  <chat_id>  <thread_id>  <message>"
    x=${1:?"Error. You must supply bot token. ${usege}"}
    x=${2:?"Error. You must supply bot chat id. ${usege}"}
    x=${3:?"Error. You must supply bot chat thread id. ${usege}"}
    x=${4:?"Error. You must supply bot message. ${usege}"}
    curl -X POST -H "Content-Type:multipart/form-data" \
    -F chat_id=$2 \
    -F message_thread_id=$3 \
    -F text="$4 $5" \
    "https://api.telegram.org/bot$1/sendMessage" >/dev/null
}
test -e /usr/bin/vault && complete -C /usr/bin/vault vault || true
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
# https://raw.githubusercontent.com/shkodina/home-cnf-common-library/refs/heads/main/bash/common-first/yc.sh
function yc-activate-profile () {
    local profile=$(yc config profile list | cut -d ' ' -f1 | fzf)
    yc config profile activate ${profile}
    sed -i "/YC_TOKEN=/d" ~/.bashrc
    export YC_TOKEN=$(yc iam create-token)
    export YC_CLOUD_ID=$(yc config get cloud-id)
    export YC_FOLDER_ID=$(yc config get folder-id)
}
alias fyc-profile-activate=yc-activate-profile
function fyc-set-external-yc-token () {
    sed -i "/YC_TOKEN=/d" ~/.bashrc
    echo export YC_TOKEN=$1 | tee -a ~/.bashrc
}
function fyc-get-vmid () {
    local vm=$(yc compute instance list --format json | jq -r .[].name | fzf)
    local vmid=$(yc compute instance get --name $vm --format json | jq -r .id)
    echo $vmid
}
function fyc-ssh () {
    yc compute ssh   --id $(fyc-get-vmid)   --identity-file ~/.ssh/id_rsa
}
function fyc-subnet-list () {
    yc vpc subnet list --format json | yq .[].name
}
function fyc-subnet-list-used-ip () {
    local snet=$(fyc-subnet-list | fzf)
    echo yc vpc subnet list-used-addresses --name $snet >&2
    yc vpc subnet list-used-addresses --name $snet --format json |
    jq -c .[] |
    while read sss;
    do
        local ip=$(echo $sss | yq .address)
        local ref=$(echo $sss | yq .references.[].referrer.type)
        echo "$ip|$ref"
    done
}
function fyc-cert-request-get-txt-records () {
  yc resource-manager folder list --format json |
  jq -r .[].name |
  while read fldname;
  do
    yc certificate-manager certificate list \
        --folder-name ${fldname} \
        --format json --full | jq -c .[] |
    grep 'yc.lime-shop.com' |
    grep PENDING'' |
    jq -r .name |
    while read certname;
    do
      yc certificate-manager certificate get \
        --folder-name ${fldname} \
        --name ${certname} \
        --format json --full |
        jq -r .challenges |
        jq -c .[] |
        grep '"type":"TXT"'
    done
  done |
  while read challenge;
  do
    name=$(echo ${challenge} | jq -r .dns_challenge.name)
    type=$(echo ${challenge} | jq -r .dns_challenge.type)
    value=$(echo ${challenge} | jq -r .dns_challenge.value)
    # echo -e "${type}|${name}|${value}"
    echo -e "\nNAME: ${name}\nVALUE: ${value}\n"
  done
}   ###    ##       ####    ###     ######  ########  ######
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
        "cleanup" | "selector" )
            $sudo_prefix docker image prune -af
            $sudo_prefix docker builder prune -af
            $sudo_prefix docker system prune -af
            return
        ;;
        "build" | "selector" )
            local docker_file=$(find . -iname "*dockerfile" | fzf)
            local docker_image_tmp_version="666.6.6-$(date +%N)"
            local docker_image_tmp_tag_name="x-$(basename $(dirname ${docker_file} | tr "[A-Z]." "[a-z]-") | tr -d -c '[a-z][A-Z][0-9]_.-' | sed 's/^\.*//')-to-delete:${docker_image_tmp_version}"
            echo "$sudo_prefix docker build --network host --build-arg BUILD_VERSION=${docker_image_tmp_version} --build-arg CI_JOB_TOKEN=${LIME_SHINE_GITLAB_TOKEN_VALUE} -t $docker_image_tmp_tag_name -f $docker_file ."
            $sudo_prefix docker build --network host --build-arg BUILD_VERSION=${docker_image_tmp_version} --build-arg CI_JOB_TOKEN=${LIME_SHINE_GITLAB_TOKEN_VALUE} -t $docker_image_tmp_tag_name -f $docker_file .
            return
        ;;
        "open-pwd-dir-in-selected-image" | "run" | "selector" )
            local limage=$($FUNCNAME select-i)
            read -p 'enter port number for listen: ' lport
            read -p 'enter user uuid:guid for run: ' luser
            set -o xtrace
            $sudo_prefix docker run --rm --name tmp-run-$$ \
                        -it \
                        -p ${lport:-"5000"}:${lport:-"5000"} \
                        --user ${luser:-"0:0"} \
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
function  fhomecnf-update-libs () {
    wget ${HOME_CNF_LIBRARY__ALL_RAW__URL} -O ${HOME_CNF_LIBRARY__ALL_RAW__LFILE}
}
