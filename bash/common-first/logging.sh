function f_log_title () {
    echo ""
    echo -e "${CLR_GREEN}#################################################"
    echo -e "${CLR_GREEN}##"
    echo -e "${CLR_GREEN}##  $@"
    echo -e "${CLR_GREEN}##"
    echo -e "${CLR_GREEN}#################################################"
    echo -e "${CLR_NC}"
}

function f_log_error () {
    echo ""
    echo -e "${CLR_RED}#################################################"
    echo -e "${CLR_RED}##  $@"
    echo -e "${CLR_RED}#################################################"
    echo -e "${CLR_NC}"
} >&2

function f_log_warn () {
    echo -e "${CLR_YELLOW}##  $@"
    echo -e "${CLR_NC}"
}

function f_log_info () {
    echo -e "${CLR_GREEN}##  $@"
    echo -e "${CLR_NC}"
}

function f_log_timestamp () { date +"%T %d"/%m/%Y ;}
