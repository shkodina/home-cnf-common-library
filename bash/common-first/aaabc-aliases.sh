 ######   ######## ########         ######## #### ######## ##       ########   ######  
##    ##  ##          ##            ##        ##  ##       ##       ##     ## ##    ## 
##        ##          ##            ##        ##  ##       ##       ##     ## ##       
##   #### ######      ##    ####### ######    ##  ######   ##       ##     ##  ######  
##    ##  ##          ##            ##        ##  ##       ##       ##     ##       ## 
##    ##  ##          ##            ##        ##  ##       ##       ##     ## ##    ## 
 ######   ########    ##            ##       #### ######## ######## ########   ###### 

alias first="tr '\t' ' ' | cut -d' ' -f1"
alias f1='first'
alias second='while read x1 x2 last; do echo "$x2"; done'
alias f2='second'
alias third='while read x1 x2 x3 last; do echo "$x3"; done'
alias f3='third'
alias forth='while read x1 x2 x3 x4 last; do echo "$x4"; done'
alias f4='forth'
alias fifth='while read x1 x2 x3 x4 x5 last; do echo "$x5"; done'
alias f5='fifth'
alias body="tail -n +2"

# function ak() { awk "{print \$${1:-1}}"; }

 ######  ##    ##  ######  ######## ######## ##     ## 
##    ##  ##  ##  ##    ##    ##    ##       ###   ### 
##         ####   ##          ##    ##       #### #### 
 ######     ##     ######     ##    ######   ## ### ## 
      ##    ##          ##    ##    ##       ##     ## 
##    ##    ##    ##    ##    ##    ##       ##     ## 
 ######     ##     ######     ##    ######## ##     ## 

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
alias reinit='source ~/.bashrc'

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


