function fkc-pv-kill () {
  test "$1" == "" && kubectl patch pv $(kubectl get pv | grep Terminating | fzf | cut -d' ' -f1) -p '{"metadata": {"finalizers": null}}'
  test "$1" == "" || kubectl patch pv "$1" -p '{"metadata": {"finalizers": null}}'
}


function fkc-pvc-kill () {
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
