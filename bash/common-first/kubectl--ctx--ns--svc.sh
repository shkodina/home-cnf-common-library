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
