
function fish_right_prompt
  set -l last_status $status

  if test $last_status = 0
    set_color green
  else
    set_color red
  end
  date "+%T"
  set_color normal
end
