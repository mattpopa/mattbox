# Task ticket number/id prefixed in git commit message

This scripts expects you're using a branch with the jira/linear ticket in its name, like:
`feature/ABC-123` or `ABC-123`

grabs the ticket format from the branch name and sets it automatically in your git commit msg, making it easier to
keep ticket references.

It's doing this using `.git/hooks/prepare-commit-msg`. so it will update your repo's git hook with this [prepare-commit-msg](./prepare-commit-msg). 

It will ignore branches like `develop` and `master`.

## How to set this up

* Run `update_hooks.sh` script, e.g. `./update_hooks.sh ~/my_repos` and if you don't provide any path it will run looking for .git/hooks in the current folder.
