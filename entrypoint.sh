echo "[+] Action start"
USERNAME=$1
REPOSITORY=$2
BRANCH=$3
DIRECTORY=$4
REMOTEDIR=$5
FILTER=$6
MESSAGE=$7

CLONE_DIR=$(mktemp -d)
GIT_CMD_REPOSITORY="git@github.com:$USERNAME/$REPOSITORY.git"

echo "[+] Git version"
git --version
git config --global user.email "$(git log -n 1 --pretty=format:%ae)"
git config --global user.name "$(git log -n 1 --pretty=format:%an)"

echo "[+] Cloning destination git repository $GIT_CMD_REPOSITORY..."
git clone --single-branch --depth 1 --branch "main" "$GIT_CMD_REPOSITORY" "$CLONE_DIR"

echo "[+] Deleting existing Go files so changes will propagate..."
find $CLONE_DIR -type f \( $FILTER \) -delete

echo "[+] Files that will be pushed"
ls -la "$DIRECTORY/."
if [ -z "$REMOTEDIR" ]
then
  cp -Rau "$DIRECTORY/." "$CLONE_DIR/$REMOTEDIR"
  cd "$CLONE_DIR/$REMOTEDIR"
else
  cp -Rau "$DIRECTORY/." "$CLONE_DIR"
  cd "$CLONE_DIR"
fi

echo "[+] Set directory is safe ($CLONE_DIR)"
git config --global --add safe.directory "$CLONE_DIR"

echo "[+] Adding generated files..."
git add --all

echo "[+] git status:"
git status

echo "[+] git diff-index:"
git diff-index --quiet HEAD || git commit -m "$MESSAGE"

echo "[+] Pushing git commit"
git push "$GIT_CMD_REPOSITORY" --set-upstream $BRANCH
