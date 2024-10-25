function fcnf-add-data-after-mask-from-file-in-file () {
    local mask=$1
    local data_file=$2
    local cnf_file=$3

    sed -i "/$mask/ r $data_file" $cnf_file
}
