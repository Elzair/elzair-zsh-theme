PROMPT='
$fg[cyan]%m: $fg[yellow]$(get_pwd)$(put_spacing)$(git_prompt_info) 
$reset_color→ '
function get_pwd() {
  echo "${PWD/$HOME/~}"
}
function put_spacing() {
  local git=$(git_prompt_info)
  if [ ${#git} != 0 ]; then
    ((git=${#git} - 10))
  else
    git=0
  fi
  local bat=10
  local termwidth
  (( termwidth = ${COLUMNS} - 3 - ${#HOST} - 6 - ${#$(get_pwd)} - ${bat} - ${git} ))
  local spacing=""
  for i in {1..$termwidth}; do
    spacing="${spacing} "
  done
  echo $spacing
}
function git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_PREFIX$(current_branch)$ZSH_THEME_GIT_PROMPT_SUFFIX"
}
function battery_charge() {
  local current=$(ioreg -l | grep CurrentCapacity | awk {'print $5'})
  current="${current}.0"
  local max=$(ioreg -l | grep MaxCapacity | awk {'print $5'})
  max="${max}.0"
  local numbars=$((current*100.0/max%101/10))
  local bars=""
  for ((i=0; i<numbars; i++)); do
    bars="${bars}▶"
  done
  for ((i=numbars; i<10; i++)); do
    bars="${bars}▷"
  done
  echo $bars
}
ZSH_THEME_GIT_PROMPT_PREFIX="[git:"
ZSH_THEME_GIT_PROMPT_SUFFIX="]$reset_color"
ZSH_THEME_GIT_PROMPT_DIRTY="$fg[red]+"
ZSH_THEME_GIT_PROMPT_CLEAN="$fg[green]"
