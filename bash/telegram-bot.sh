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
