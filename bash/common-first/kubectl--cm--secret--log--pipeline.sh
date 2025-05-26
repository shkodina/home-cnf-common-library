##        #######   ######
##       ##     ## ##    ##
##       ##     ## ##
##       ##     ## ##   ####
##       ##     ## ##    ##
##       ##     ## ##    ##
########  #######   ######

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
    grep -i -E "URL|gitlab_cnf_link" | 
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
  xargs -I {} kubectl get cm -oyaml {}-cm-deploy-info | 
  yq .data
}
alias fginfof=fginfo-full