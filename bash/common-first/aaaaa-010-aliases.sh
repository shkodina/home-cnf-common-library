 ######   ######## ########         ######## #### ######## ##       ########   ######  
##    ##  ##          ##            ##        ##  ##       ##       ##     ## ##    ## 
##        ##          ##            ##        ##  ##       ##       ##     ## ##       
##   #### ######      ##    ####### ######    ##  ######   ##       ##     ##  ######  
##    ##  ##          ##            ##        ##  ##       ##       ##     ##       ## 
##    ##  ##          ##            ##        ##  ##       ##       ##     ## ##    ## 
 ######   ########    ##            ##       #### ######## ######## ########   ###### 

alias f1='while read x1 last; do echo "$x1"; done'
alias f2='while read x1 x2 last; do echo "$x2"; done'
alias f3='while read x1 x2 x3 last; do echo "$x3"; done'
alias f4='while read x1 x2 x3 x4 last; do echo "$x4"; done'
alias f5='while read x1 x2 x3 x4 x5 last; do echo "$x5"; done'
alias f6='while read x1 x2 x3 x4 x5 x6 last; do echo "$x6"; done'
alias f7='while read x1 x2 x3 x4 x5 x6 x7 last; do echo "$x7"; done'
alias f8='while read x1 x2 x3 x4 x5 x6 x7 x8 last; do echo "$x8"; done'
alias f9='while read x1 x2 x3 x4 x5 x6 x7 x8 x9 last; do echo "$x9"; done'
alias body="tail -n +2"

# function ak() { awk "{print \$${1:-1}}"; }

 ######  ##    ##  ######  ######## ######## ##     ## 
##    ##  ##  ##  ##    ##    ##    ##       ###   ### 
##         ####   ##          ##    ##       #### #### 
 ######     ##     ######     ##    ######   ## ### ## 
      ##    ##          ##    ##    ##       ##     ## 
##    ##    ##    ##    ##    ##    ##       ##     ## 
 ######     ##     ######     ##    ######## ##     ## 

alias clock='tty-clock -s -b -x -n -C 5 '

alias ll='ls -alhs --time-style="+%Y.%m.%d_%T"'
alias l='ls -l --time-style="+%Y.%m.%d_%T"'
alias l1='ls -1'
alias rm='rm -rf '
alias q='exit 0'
alias watch='watch '
alias tto='touch'
alias xa='xargs '
alias xargs='xargs '

alias d64='base64 -d'
alias reinit='fhomecnf-update-libs; source ~/.bashrc' # bash/personal-second/helpers.sh

alias rmlinks='find . -maxdepth 1 -type l | xargs rm'

alias off='sudo poweroff'
alias poweroff='sudo poweroff '
alias reboot='sudo reboot '

##     ##    ###    ######## ##     ## 
###   ###   ## ##      ##    ##     ## 
#### ####  ##   ##     ##    ##     ## 
## ### ## ##     ##    ##    ######### 
##     ## #########    ##    ##     ## 
##     ## ##     ##    ##    ##     ## 
##     ## ##     ##    ##    ##     ##

alias summ='paste -sd+ | bc'

##    ## ########  ######## ##      ## 
##   ##  ##     ## ##       ##  ##  ## 
##  ##   ##     ## ##       ##  ##  ## 
#####    ########  ######   ##  ##  ## 
##  ##   ##   ##   ##       ##  ##  ## 
##   ##  ##    ##  ##       ##  ##  ## 
##    ## ##     ## ########  ###  ### 

export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

alias kube-capacity='kubectl resource-capacity'

# read  ga-vm-configs/krew
