#!/bin/bash
#
# Utility script used to configure .gitconfig and .gitattributes behind the scene
# The script will automatically add to .gitconfig the follwing bit if any of the following tags was not previously added
#
# [merge "ansible-vault"]
#    name = ansible-vault merge driver
#    driver = ${SCRIPT_PATH}/ansible-vault-merge %O %A %B %P
# [diff "vault"]
#    textconv = ansible-vault view
#    cachetextconv = false
# [diff "ansible-vault"]
#    textconv = ansible-vault view
#    cachetextconv = false
# It will also add to .gitattribute the following bit if was not previously added
# *.vault diff=ansible-vault merge=ansible-vault
#
# Usage: ./install.sh from project root folder


set -eo

SCRIPT_PATH="$( pwd )"
MERGE_SCRIPT_PATH="${SCRIPT_PATH}/ansible-vault-merge"

echo "Checking ${MERGE_SCRIPT_PATH} file"
if [[ ! -f "${MERGE_SCRIPT_PATH}" ]]; then
	echo "ansible-vault-merge script not found in path ${MERGE_SCRIPT_PATH}"
	exit 1
fi

pushd ~/

echo "Adding attributesfile property in `pwd`/.gitconfig"
if ! grep "attributesfile" .gitconfig ; then
	sed -i -E 's/\[core\]/\[core\] \
	attributesfile = ~\/.gitattributes/g' .gitconfig 
fi

read -d '' GIT_CONFIG_CONTENT << EOM || true
[merge "ansible-vault"]
    name = ansible-vault merge driver
    driver = ${SCRIPT_PATH}/ansible-vault-merge %O %A %B %P
[diff "vault"]
    textconv = ansible-vault view
    cachetextconv = false
[diff "ansible-vault"]
    textconv = ansible-vault view
    cachetextconv = false
EOM

read -d '' GIT_ATTR_CONTENT << EOM || true
*.vault diff=ansible-vault merge=ansible-vault
EOM

echo "Checking if `pwd`/.gitconfig was previous configured"
if ! grep -E "(?:merge \"ansible-vault\"|diff \"vault\"|diff \"ansible-vault\")" .gitconfig ; then
	echo "Configuring `pwd`/.gitconfig"
	echo "$GIT_CONFIG_CONTENT" | tee -a .gitconfig
fi

echo "Checking if `pwd`/.gitattributes was previous configured"
if ! grep "${GIT_ATTR_CONTENT}" .gitattributes ; then
	echo "Configuring `pwd`/.gitattributes"
	echo "$GIT_ATTR_CONTENT" | tee -a .gitattributes
fi
