#!/bin/bash
# script for staging everything, committing and pushing
# from there docker builds the image

set -o errexit	# abort script at first error
set -o pipefail	# return the exit status of the last command in the pipe
set -o nounset	# treat unset variables and parameters as an error
#set -x		# Use during debugging

VERSION_OPTS=("--major" "--minor" "--patch")
VERSION_FILE=$(pwd)/../cfgs/VERSION
VERSION=$(cat $VERSION_FILE)
COMMIT_MSG=""
VERSION_MODE=""

print_usage()
{
	printf "\nUsage:\n"
	printf "\$1: {--major|--minor|--patch} # Increments either by +1\n"
	printf "\$2: commit message # e.g.: \"Added new feature\"\n"
	exit 1
}

determine_args()
{
	if [[ ${VERSION_OPTS[*]} =~ $1 ]] ; then
		VERSION_MODE=$1
		COMMIT_MSG=false
	else
		VERSION_MODE=false
		COMMIT_MSG=$1
	fi
}

if [[ "$#" -gt 2 || "$#" -eq 0 ]] ; then
	print_usage
else
	if [ "$#" -eq 1 ] ; then
		determine_args "$1"
	else
		VERSION_MODE=$1
		COMMIT_MSG=$2
		
	fi
fi

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
		VERSION_MODE=$patch
	elif [ "$arg" = "$minor" ] ; then
		let "mi=mi+1"
		pa=0
		VERSION_MODE=$minor
	elif [ "$arg" = "$major" ] ; then
		let "ma=ma+1"
		mi=0
		pa=0
		VERSION_MODE=$major
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

if [ "$VERSION_MODE" != "false" ] ; then
	increment_version $VERSION_MODE
	update_version_file
	COMMIT_MSG="Version updated to $VERSION"
fi

if [[ "$COMMIT_MSG" != false && "$#" -eq 2 ]] ; then 
	COMMIT_MSG="$2"
fi


printf "\nAdding, committing and pushing changes to origin...\n"

git add .
git commit -am "$COMMIT_MSG"
git push origin

exit 0
