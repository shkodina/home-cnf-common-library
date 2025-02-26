
command -v helm && complete -o default -F __start_helm helm
command -v helm && source <(helm completion bash)

function fhelm-roll-back-chart-by-grep-from-history () {

    APP=${1:?"Error. You must supply helm release name."}
    GREP_STR=${2:?"Error. You must supply a grep string to select revision."}

    helm history ${APP} | grep -v "${GREP_STR}" | while read rrev stub; do echo $rrev $stub; echo $rrev; let rrev--; echo $rrev; helm rollback ${APP} $rrev; done
}


function fhelm-roll-back-last () {

    APP=${1:?"Error. You must supply helm release name."}

    helm history ${APP} | tail -n 1 | while read rrev stub; do echo $rrev $stub; echo $rrev; let rrev--; echo $rrev; helm rollback ${APP} $rrev; done
}



function fhelm () {
    helm $@ $(  helm list -a | 
                fzf | 
                while read x1 stuff; do echo $x1; done
            )
}

