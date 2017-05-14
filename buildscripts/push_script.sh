#!/bin/bash
# script for staging everything, committing and pushing
# from there docker builds the image

set -o errexit	# abort script at first error
set -o pipefail	# return the exit status of the last command in the pipe
set -o nounset	# treat unset variables and parameters as an error
set -x		# Use during debugging

if [ "$#" -ne 2 ] ; then
	printf "\nUsage:\n"
	printf "\$1: {--major|--minor|--patch} # Increments either by +1\n"
	printf "\$2: commit message # e.g.: \"Added new feature\"\n"
	exit 1
fi

VERSION_FILE=$(pwd)/../cfgs/VERSION
VERSION=$(cat $VERSION_FILE)
COMMIT_MSG=$2

increment_version()
{
	local arg=$1
	local version_arr=(${VERSION//\./ })
	local major="--major"
        local minor="--minor"
       	local patch="--patch"
	local ma=${version_arr[0]}
	local mi=${version_arr[1]}
	local pa=${version_arr[2]}
	if [ "$arg" = "$patch" ] ; then
		let "pa=pa+1"
	elif [ "$arg" = "$minor" ] ; then
		let "mi=mi+1"
		pa=0
	elif [ "$arg" = "$major" ] ; then
		let "ma=ma+1"
		mi=0
		pa=0
	else
		exit 1
	fi
	VERSION=$ma.$mi.$pa
}

update_version_file()
{
	echo $VERSION > $VERSION_FILE
	printf "\nUpdated Version in $VERSION_FILE to $(cat ${VERSION_FILE})\n"
}

printf "\nAdding, committing and pushing changes to origin...\n"

increment_version $1
update_version_file
git add .
git commit -am "$COMMIT_MSG"
git push origin

exit 0
