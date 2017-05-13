#!/bin/bash
# script for staging everything, committing and pushing
# from there docker builds the image

set -o errexit    # abort script at first error
set -o pipefail   # return the exit status of the last command in the pipe
set -o nounset    # treat unset variables and parameters as an error

# block for creating proper version number
# version pattern: major.minor.revision
# exmaple: 1.5.99
VERSION_FILE=$(pwd)/../cfgs/VERSION
VERSION=$(cat $VERSION_FILE)
COMMIT_MSG="$VERSION"
if [ "$#" -eq 1 ]; then
	COMMIT_MSG="$VERSION: $1"
fi

printf "\nAdding, committing and pushing changes to origin...\n"

git add .
git commit -m "$COMMIT_MSG"
git push origin

