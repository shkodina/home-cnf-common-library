
 ######   #######  ##     ## ##     ## #### ######## 
##    ## ##     ## ###   ### ###   ###  ##     ##    
##       ##     ## #### #### #### ####  ##     ##    
##       ##     ## ## ### ## ## ### ##  ##     ##    
##       ##     ## ##     ## ##     ##  ##     ##    
##    ## ##     ## ##     ## ##     ##  ##     ##    
 ######   #######  ##     ## ##     ## ####    ##  

function fgit-safe-commit () {
  git pull

  test "$1" == "" && git-commiter fast
  test "$1" == "." && test -z "$2" && git-commiter || git-commiter fast "$2"

  test -e ./pre-fgsc-hook.sh && ./pre-fgsc-hook.sh

  git commit -am "$GC_MESSAGE"
  git push
  echo -e  "${CLR_GREEN}$(git config --get remote.origin.url | tr ':' '/' | sed -e 's/git@/http:\/\//' | sed -e 's/http:\/\/ssh-/http:\/\//' | sed -e 's/\.git/\/-\/pipelines/')${CLR_NC}"
  echo -e "${CLR_YELLOW}$(git config --get remote.origin.url | tr ':' '/' | sed -e 's/git@/http:\/\//' | sed -e 's/http:\/\/ssh-/http:\/\//' | sed -e 's/\.git/\/-\/commits/'  )${CLR_NC}"
  test -z "${1}" && echo -e "Search commit message: ${CLR_GREEN}fast change commit $(date '+%Y.%m.%d %T')${CLR_NC}"
}

 ######   #######  ##     ## ##     ## #### ######## ######## ######## ########  
##    ## ##     ## ###   ### ###   ###  ##     ##       ##    ##       ##     ## 
##       ##     ## #### #### #### ####  ##     ##       ##    ##       ##     ## 
##       ##     ## ## ### ## ## ### ##  ##     ##       ##    ######   ########  
##       ##     ## ##     ## ##     ##  ##     ##       ##    ##       ##   ##   
##    ## ##     ## ##     ## ##     ##  ##     ##       ##    ##       ##    ##  
 ######   #######  ##     ## ##     ## ####    ##       ##    ######## ##     ## 
 
function git-commiter () {

  local gc_types="\n
    build: Сборка проекта или изменения внешних зависимостей\n
    ci: Настройка CI и работа со скриптами\n
    chore: Правки от Девопсов\n
    docs: Обновление документации\n
    feat: Добавление нового функционала\n
    fix: Исправление ошибок\n
    perf: Изменения направленные на улучшение производительности\n
    refactor: Правки кода без исправления ошибок или добавления новых функций\n
    revert:	Откат на предыдущие коммиты\n
    style: Правки по кодстайлу (табы, отступы, точки, запятые и т.д.)\n
    test: Добавление или просто обработка тестов
  "
  local gc_scopes="\n
    pipe: пайплайн и иже с ним\n
    scripts: скрипты\n
    inventory: окружения\n
    roles: роли\n
    configs: настройки и конфигурации\n
    components: компаненты\n
    tutorial: маны\n
    custom: свой scope
  "

  if [ "$1" == "fast" ]
  then
    gc_type="chore"
    gc_scope="all"
    test "$2" == "" && gc_head="fast change commit $(date '+%Y.%m.%d %T')" || gc_head="$2"
    gc_body="$(git diff --name-only | tr '\n' '|')"
  else
    echo "Выбери тип коммита:"      && gc_type=$(echo -e ${gc_types}  | sort | fzf | cut -d: -f1 | tr -d ' ')
    echo "Выбери область коммита:"  && gc_scope_t=$(echo -e ${gc_scopes} | fzf | cut -d: -f1 | tr -d ' ')

    test "$gc_scope_t" == "custom" && read -p "Задай свой scope: " gc_scope || gc_scope=$gc_scope_t

    read -p "Дай краткий заголовок коммита: " gc_head
    read -p "Дай описание коммита (новая строка через |): " gc_body 
    read -p "Добавь meta данные: " gc_meta 
  fi

  local gc_message=$(echo -e "$gc_type($gc_scope): $gc_head\n\nbody:\n$(echo $gc_body | tr '|' \\n)$(test -z $gc_meta || echo -e '\n\n'meta: $gc_meta)" )

  echo -e "$gc_message"
  export GC_MESSAGE="$gc_message"
}


   ###    ##       ####    ###     ######  ########  ######  
  ## ##   ##        ##    ## ##   ##    ## ##       ##    ## 
 ##   ##  ##        ##   ##   ##  ##       ##       ##       
##     ## ##        ##  ##     ##  ######  ######    ######  
######### ##        ##  #########       ## ##             ## 
##     ## ##        ##  ##     ## ##    ## ##       ##    ## 
##     ## ######## #### ##     ##  ######  ########  ######  

alias fgsc='fgit-safe-commit'

alias fgps='fgit pull && git submodule update --remote'
alias fgpr='fgit pull-rebase'
alias fgcnb='git checkout -b '

alias fgr='fgit reset'
alias fgb='fgit branch'
alias fgp='fgit pull'
alias fgp-all='fgit pull-all'
alias fgp-all-daemon='fgit pull-all-in-daemon'
alias fgurl='fgit get-base-url'
alias fgit-untracked='fgit untracked'
alias fgc='fgit checkout'

##     ## ######## ##       ########  ######## ########  
##     ## ##       ##       ##     ## ##       ##     ## 
##     ## ##       ##       ##     ## ##       ##     ## 
######### ######   ##       ########  ######   ########  
##     ## ##       ##       ##        ##       ##   ##   
##     ## ##       ##       ##        ##       ##    ##  
##     ## ######## ######## ##        ######## ##     ## 

function fgit () {
    local sudo_prefix=
    test "$(whoami)" == "root" || sudo_prefix=sudo
  
    local cmd=$1
    test "$cmd" == "" && cmd=$(type $FUNCNAME | grep selector | grep -v grep | cut -d'"' -f2 | fzf)

    case $cmd in

#     #               
#     # #####  #      
#     # #    # #      
#     # #    # #      
#     # #####  #      
#     # #   #  #      
 #####  #    # ###### 

        "get-base-url" | "selector" ) 
            git config --get remote.origin.url | 
            tr ':' '/' | 
            sed -e 's/git@/http:\/\//' |
            sed -e 's/http:\/\/ssh-/http:\/\//'
            return ;;


        "url" | "selector" ) $FUNCNAME get-base-url ; return ;;

######                                     
#     # #####    ##   #    #  ####  #    # 
#     # #    #  #  #  ##   # #    # #    # 
######  #    # #    # # #  # #      ###### 
#     # #####  ###### #  # # #      #    # 
#     # #   #  #    # #   ## #    # #    # 
######  #    # #    # #    #  ####  #    # 

        "branch" | "selector" )
            git rev-parse HEAD > /dev/null 2>&1 || return
            git branch -a --color=always --sort=-committerdate |
                grep -v HEAD |
                fzf --height 50% --ansi --no-multi --preview-window right:65% \
                    --preview 'git log -n 50 --color=always --date=short --pretty="format:%C(auto)%cd %h%d %s" $(sed "s/.* //" <<< {})' | sed "s/.* //"

            return ;;

        "reset" | "selector" ) git reset --hard HEAD ; return ;;
  
######          #####                              
#     # ###### #     # #       ####  #    # ###### 
#     # #      #       #      #    # ##   # #      
######  #####  #       #      #    # # #  # #####  
#   #   #      #       #      #    # #  # # #      
#    #  #      #     # #      #    # #   ## #      
#     # ######  #####  ######  ####  #    # ###### 

        "re-clone" | "selector" ) 
            local dir=${PWD##*/}  #  name of current dir
            local gurl="$(git config --get remote.origin.url)"
            cd ..
            sudo rm -rf "$dir"
            git clone "$gurl" "$dir"
            cd "$dir"
            return ;;
  
  #     #                                          
#     # #    # ##### #####    ##    ####  #    # 
#     # ##   #   #   #    #  #  #  #    # #   #  
#     # # #  #   #   #    # #    # #      ####   
#     # #  # #   #   #####  ###### #      #  #   
#     # #   ##   #   #   #  #    # #    # #   #  
 #####  #    #   #   #    # #    #  ####  #    # 

        "untracked" | "selector" ) git ls-files --others --exclude-standard ; return ;;
        "un" | "selector" ) $FUNCNAME  untracked ; return ;;
        "un-add" | "selector" ) $FUNCNAME  untracked | xargs git add ; return ;;

 #####                              #######              
#     # #    # ######  ####  #    # #     # #    # ##### 
#       #    # #      #    # #   #  #     # #    #   #   
#       ###### #####  #      ####   #     # #    #   #   
#       #    # #      #      #  #   #     # #    #   #   
#     # #    # #      #    # #   #  #     # #    #   #   
 #####  #    # ######  ####  #    # #######  ####    #   

        "checkout" | "selector" )
            git rev-parse HEAD > /dev/null 2>&1 || return
            local branch=$($FUNCNAME branch)
            test "$branch" = "" && ( echo "No branch selected." ; return ; )

            if [[ "$branch" = 'remotes/'* ]]; then
                git checkout --track $branch
            else
                git checkout $branch;
            fi

            return ;;

#     #                             
##   ## ###### #####   ####  ###### 
# # # # #      #    # #    # #      
#  #  # #####  #    # #      #####  
#     # #      #####  #  ### #      
#     # #      #   #  #    # #      
#     # ###### #    #  ####  ###### 

        "merge-from" | "selector" )
            local br=$($FUNCNAME branch)
            local cbr=$(git branch --show-current)

            git checkout $br
            git pull
            git checkout $cbr
            git merge $br

            return ;;

######                       
#     # #    # #      #      
#     # #    # #      #      
######  #    # #      #      
#       #    # #      #      
#       #    # #      #      
#        ####  ###### ###### 

        "pull" | "selector" ) 
            git pull
            git submodule update --init --recursive
            return ;;

        "pull-rebase" | "selector" ) git pull --rebase ; return ;;

        "pull-all" | "selector" )
            find . -type d -name ".git" | while read d; 
              do 
                f_log_info "$d";
                git -C ${d%/*}/ pull; 
              done
            return ;;

        "pull-all-in-daemon" | "selector" )
            find . -type d -name ".git" | while read d; 
              do 
                f_log_info "$d";
                git -C ${d%/*}/ pull &  
              done
            return ;;


        * ) 
            >&2 echo "wrong command:   $cmd"
            >&2 echo "available commands are:"
            type $FUNCNAME | grep selector | grep -v grep | cut -d'"' -f2
            return
        ;;
    esac

}

alias fgg=fgit

 ######   ######## ##    ##       ##     ## ######## ########  
##    ##  ##       ###   ##       ##     ## ##       ##     ## 
##        ##       ####  ##       ##     ## ##       ##     ## 
##   #### ######   ## ## ##       ##     ## ######   ########  
##    ##  ##       ##  ####        ##   ##  ##       ##   ##   
##    ##  ##       ##   ###         ## ##   ##       ##    ##  
 ######   ######## ##    ##          ###    ######## ##     ## 

function f_lib_generate_version () {
    # если откудато уже пришла версия то сохраним ее
    local PREDEFINED_VERSION=$VERSION

    git describe --tags --always --abbrev=8

    test $(git describe --tags --always --abbrev=8 | sed -E 's/^v//g' | sed -E 's/^\.//g' | grep -c '\.') -gt 0 \
            && VERSION=$(git describe --tags --always --abbrev=8 | sed -E 's/^v//g' | sed -E 's/^\.//g' | tr '()' '.' | sed -E "s/\.+$//" ) \
            || VERSION=0.0.1-$(git log | grep -c commit)-$(git describe --tags --always --abbrev=8 | tr '()' '.' | sed -E "s/\.+$//")

    test $VERSION_PREFIX && VERSION=$VERSION_PREFIX-$VERSION
    test $VERSION_SUFFIX && VERSION=$VERSION-${VERSION_SUFFIX//:/-}

    echo "$CI_BUILD_REF_NAME" | grep -q debug && VERSION=$VERSION-debug || true

    # тут если версия из артефатов или первого объеявления не пуста и не совпала
    test "$PREDEFINED_VERSION" != "" && \
        test "$PREDEFINED_VERSION" != "$VERSION" && \
            f_log_info "PREDEFINED_VERSION: $PREDEFINED_VERSION  DIFF FROM VERSION: $VERSION" && \
                export VERSION=$PREDEFINED_VERSION

    # тут если версия юзерская и не совпала, то сделаем мегакостылем ее главной
    test "$USER_DEFINED_VERSION" != "" ] && \
        test "$USER_DEFINED_VERSION" != "$VERSION" && \
            f_log_info "USER_DEFINED_VERSION: $USER_DEFINED_VERSION  DIFF FROM VERSION: $VERSION" && \
                export VERSION=$USER_DEFINED_VERSION

    export VERSION=$VERSION
    # echo VERSION="${VERSION}" > $CI_PROJECT_DIR/variables.env
}

alias fgs='git status -s'

