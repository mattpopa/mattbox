#!/usr/bin/env bash

# Runs on path of working directory (from where you run it), or specify the relative repo dir path, e.g. ~/my_projects_git_repos
[[ $# -gt 1  ]] && { echo "Usage: $0 [optional: starting path, defaults to pwd], e.g. $0 ~/my_company_repos" ; exit 1; }

# Set pwd, defaults to current dir if no path provided
if [ -z "$1" ]
  then
    WORKSPACE="."
  else
    WORKSPACE=$1
fi

# Globals
SAMPLE_FILE="prepare-commit-msg.sample"
PREFIX_HOOK="prepare-commit-msg"
ALL_REPOS="$(find "$WORKSPACE" -type f -name $SAMPLE_FILE | sed -E 's|/[^/]+$||' | sort -u)"

function update_hook() {
  local new_hook="$(< $PREFIX_HOOK)"
  for path in $ALL_REPOS; do

    pushd "$path" || exit 1
    echo "🏃  Running on $path, updating prepare-commit-msg..."
    echo "$new_hook" > $PREFIX_HOOK && chmod +x $PREFIX_HOOK
    popd
  done
}

update_hook && echo "✅  Done, $PREFIX_HOOK hooks updated"
