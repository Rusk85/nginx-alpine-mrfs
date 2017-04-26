#build script for rusk85/nginx-alpine-mrfs

TAG=rusk85/nginx-alpine-mrfs

# block for creating proper version number
# version pattern: major.minor.revision
# exmaple: 1.5.99
VERSION_FILE=$(pwd)/VERSION
VERSION=$(cat $VERSION_FILE)
COMMIT_MSG="Added latest changes"
if [ "$#" -eq 1 ]; then
	COMMIT_MSG=$1
fi

printf "\nAdding, committing and pushing changes to origin...\n"

git add .
git commit -m "$VERSION: $COMMIT_MSG"
git push origin
