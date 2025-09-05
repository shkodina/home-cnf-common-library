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


