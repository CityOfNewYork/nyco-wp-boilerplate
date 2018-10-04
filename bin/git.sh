
function git_clean {
  printf "\xF0\x9F\x94\xAC     Git status... ";
  if [ -z "$(git status --porcelain)" ]; then
    echo "Working directory clean!"
  else
    echo "There are uncommitted changes in your branch. Stash, revert, or commit them to procede."
    exit 0
  fi
}

function git_add {
  printf "\xF0\x9F\x94\xAC     Staging commit... ";
  if eval $1 ; then
    echo "Staged!"
  else
    echo "Staging failed."
    exit 0
  fi
}

function git_commit {
  printf "\xF0\x9F\x94\xAC     Committing changes... ";
  if eval $1 ; then
    printf ""
  else
    printf ""
    exit 0
  fi
}

function git_tag {
  printf "\xF0\x9F\x94\xAC     Tagging repository... ";
  if eval $1 ; then
    echo "Tagged!"
  else
    printf ""
    exit 0
  fi
}