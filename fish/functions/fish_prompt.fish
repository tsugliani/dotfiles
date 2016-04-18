# name: clearance
# ---------------
# Based on idan. Display the following bits on the left:
# - Virtualenv name (if applicable, see https://github.com/adambrenecki/virtualfish)
# - Current directory name
# - Git branch and dirty state (if inside a git repo)

function fish_title
    echo "Terminal"
end


function _git_branch_name
  echo (command git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
end

function _git_is_dirty
  echo (command git status -s --ignore-submodules=dirty ^/dev/null)
end

function de
  /Applications/Docker/Docker\ Quickstart\ Terminal.app/Contents/Resources/Scripts/start.sh
end

function gl
  git lg
end

function glo
  git ll
end

function cat
  pygmentize -g "$argv"
end

function git_stuff
  set -l bold (tput bold)
  set -l reset (tput sgr0)

  # Solarized colors, taken from http://git.io/solarized-colors.
  set -l black (tput setaf 0)
  set -l blue (tput setaf 33)
  set -l cyan (tput setaf 37)
  set -l green (tput setaf 64)
  set -l orange (tput setaf 166)
  set -l purple (tput setaf 125)
  set -l red (tput setaf 124)
  set -l violet (tput setaf 61)
  set -l white (tput setaf 15)
  set -l yellow (tput setaf 136)
  # Show git branch and status
  if [ (_git_branch_name) ]
    set -l git_branch (_git_branch_name)

    if [ (_git_is_dirty) ]
      set git_info $bold $violet $git_branch $blue ' [±]'
    else
      set git_info $bold $violet $git_branch
    end
    echo -n -s $white ' on ' $git_info $reset
  end
end

function fish_prompt
  tput sgr0; # reset colors
  set -l bold (tput bold)
  set -l reset (tput sgr0)

  # Solarized colors, taken from http://git.io/solarized-colors.
  set -l black (tput setaf 0)
  set -l blue (tput setaf 33)
  set -l cyan (tput setaf 37)
  set -l green (tput setaf 64)
  set -l orange (tput setaf 166)
  set -l purple (tput setaf 125)
  set -l red (tput setaf 124)
  set -l violet (tput setaf 61)
  set -l white (tput setaf 15)
  set -l yellow (tput setaf 136)



  set -l cwd (pwd | sed "s:^$HOME:~:")
  # Print pwd or full path

  # Terminate with a nice prompt char
  # echo -e ''
  set -l username (whoami)
  set -l hostname (hostname -s)

  echo -n -s "$bold$orange$username$white at $yellow$hostname$white in $green$cwd"
  git_stuff
  echo
  if test $CMD_DURATION
    if test $CMD_DURATION -gt (math "1000 * 5")
      set secs (math "$CMD_DURATION / 1000")
      set_color yellow
      echo -n "$secs"
      echo -n "s"
      echo -n $white "- "
    end
  end
  echo -n -s "$bold$white$prompt_color⟩ $reset"
end
