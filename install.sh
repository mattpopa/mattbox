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
# Usage: ./install.sh [--help] [-p path]
#	  --help  display help
#	  -p      specify the path to the project root where the driver should be configured


set -e

function usage {
	echo "Usage: ./install.sh [--help] [-p path]"
	echo "  --help  display help"
	echo "  -p      specify the path to the project root where the driver should be configured"
	exit 0
}

case $1 in
	--help)
		usage
		;;
	-p)
		if [[ -z $2 ]]; then
			echo "Path to the project root folder - containing .git - should be supplied"
			exit 1
		fi
		PROJECT_ROOT_PATH=$2
		;;
	*)
	  echo "Aborting as the parameters passed are not in the params list. For usage use --help"
	  exit 1
	  ;;
esac

if [[ -z ${PROJECT_ROOT_PATH} ]]; then
  PROJECT_ROOT_PATH="$(pwd)"
fi

SCRIPT_PATH="$( pwd )"
MERGE_SCRIPT_PATH="${SCRIPT_PATH}/ansible-vault-merge"
GITCONFIG_PATH="${PROJECT_ROOT_PATH}/.gitconfig"
GITATTRIBUTES_PATH="${PROJECT_ROOT_PATH}/.gitattributes"

echo "=================================="
echo "Checking ${MERGE_SCRIPT_PATH} file"
if [[ ! -f "${MERGE_SCRIPT_PATH}" ]]; then
	echo "ansible-vault-merge script not found in path ${MERGE_SCRIPT_PATH}"
	exit 1
fi
echo "${MERGE_SCRIPT_PATH} already exists"

pushd ~/

echo "Adding attributesfile property in ${GITCONFIG_PATH} if not exists"
if [[ ! -f "${GITCONFIG_PATH}" ]]; then
  echo "Creating ${GITCONFIG_PATH} as it does not exists"
  touch "${GITCONFIG_PATH}"
fi
if ! grep -q "attributesfile" "${GITCONFIG_PATH}" ; then
	sed -i '.bak' -E 's/\[core\]/\[core\] \
	attributesfile = ~\/.gitattributes/g' ${GITCONFIG_PATH}
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

echo "Checking if ${GITCONFIG_PATH} was previous configured"
if ! grep -q -E "(?:merge \"ansible-vault\"|diff \"vault\"|diff \"ansible-vault\")" "${GITCONFIG_PATH}" ; then
	echo "Configuring ${GITCONFIG_PATH}"
	echo "$GIT_CONFIG_CONTENT" | tee -a "${GITCONFIG_PATH}"
fi

echo "Checking if ${GITATTRIBUTES_PATH} was previous configured"
if [[ ! -f "${GITATTRIBUTES_PATH}" ]]; then
  echo "Creating ${GITATTRIBUTES_PATH} as it does not exists"
  touch "${GITATTRIBUTES_PATH}"
fi
if ! grep -q "${GIT_ATTR_CONTENT}" "${GITATTRIBUTES_PATH}" ; then
	echo "Configuring `pwd`/.gitattributes"
	echo "$GIT_ATTR_CONTENT" | tee -a "${GITATTRIBUTES_PATH}"
fi

echo "Cleaning up bak files"
rm -rf "${GITCONFIG_PATH}.bak"
echo "=================================="
