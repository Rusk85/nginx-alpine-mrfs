#build script for rusk85/nginx-alpine-mrfs

TAG=rusk85/nginx-alpine-mrfs

# block for creating proper version number
# version pattern: major.minor.revision
# exmaple: 1.5.99
VERSION_FILE=$(pwd)/cfgs/VERSION
VERSION=$(cat $VERSION_FILE)
COMMIT_MSG="$VERSION"
if [ "$#" -eq 1 ]; then
	COMMIT_MSG="$VERSION: $1"
fi

printf "\nAdding, committing and pushing changes to origin...\n"

git add .
git commit -m "$COMMIT_MSG"
git push origin
