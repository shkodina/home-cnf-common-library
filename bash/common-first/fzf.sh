[ -f ~/.fzf.bash ] && source ~/.fzf.bash


function prepare_select_for_fzf () {
  echo $@ | cut -d ' ' -f 3- | tr '|' '\n' | tr ' ' '\n' | sed -e '/\[/d;/\]/d;s/(.*)//' | sort | uniq
}



function run_use_select_by_fzf () {
    $1 $(prepare_select_for_fzf $($1) | fzf --border --height=15%)
}
