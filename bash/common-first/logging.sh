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
