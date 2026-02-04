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
  # local tmp=$(mktemp)
  kubectl get secrets | 
    grep tls | 
      while read n stub; do echo $n; done | 
        fzf | 
          xargs kubectl get secret -oyaml | 
            yq '.data."tls.crt"' |
              base64 -d |
                while openssl x509 -noout -text; do echo ; done

  #             base64 -d > $tmp 
  # openssl crl2pkcs7 -nocrl -certfile $tmp |
  #   openssl pkcs7 -print_certs -text -noout
}

function fkc-tls-expires-ends-in () {
  local tsnow=$(date -u +%s)
  local tmp=$(mktemp)
  local tmpts=$(mktemp)
  local tmp_tls_names=$(mktemp)  
  local max_name_length=0
  
  kubectl get secrets | grep tls | cut -d' ' -f1 > $tmp_tls_names
  max_name_length=$(cat $tmp_tls_names | while read name; do echo $name | wc -c; done | sort -d -u | tail -n 1)

  cat $tmp_tls_names |
  while read name; 
  do 
    kubectl get secret $name -oyaml | 
    yq '.data."tls.crt"' | 
    base64 -d |
    while openssl x509 -noout -text 2>>/dev/null ; do echo ; done |
    grep 'Not After :' |
    cut -d':' -f2- |
    while read ts; do date -d "$ts" +%s; done |
    sort -d -u |
    head -n 1 > $tmpts
    local target=$(cat $tmpts | head -n 1)
    local seconds=$(( target - tsnow ))
    local days=$(( seconds / 86400 ))
    printf "tls: %-${max_name_length}s expires in: %-5s days or: %s\n" "$name" "$days" "$(date -d "@$target")"
  done
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
    grep -v -E "DOCKER_LABEL__" |
    grep 'https://' |
    cut -d: -f2- |
    sort -u
    # while read k s;
    # do
    #     printf "%-35s %s\n" "$k" "$s"
    # done
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
alias fginfof=fginfo-full