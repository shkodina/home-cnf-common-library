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

# function fmtex-hide-yopass-message() {
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
