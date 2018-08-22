#!/bin/bash
set -e

REPO='belsander/docker-cronicle.git'
VERSION_FILE='VERSION'
VERSION_CMD="docker run -ti intelliops/cronicle:latest \
  /bin/bash -c '/opt/cronicle/bin/control.sh version'"


setup_git() {
  # Configure git credentials for commit messages etc
  git config --global user.email "sander@intelliops.be"
  git config --global user.name "Sander Bel (Travis CI)"
}

get_version() {
  # Get version of binary to be released
  eval "$VERSION_CMD"
}

set_version() {
  # Set version in VERSION_FILE, used for tracking version in GitHub
  echo "$1" > $VERSION_FILE
}

commit_version() {
  # Commit new version in VERSION_FILE
  git add $VERSION_FILE 2>&1 >/dev/null
  git commit --message "Bumped version: $1" 2>&1 >/dev/null
}

tag_version() {
  # Create tag at current commit
  git tag "$1" 2>&1 >/dev/null
}

push_changes() {
  # Push local changes to GitHub
  git remote add origin-auth "https://${GH_AUTH}@github.com/$REPO" 2>&1 >/dev/null
  git push --tags --quiet --set-upstream origin-auth master 2>&1 >/dev/null
}


# MAIN
echo "Releasing GitHub \"$REPO\" ..."
setup_git

VERSION=$(get_version)
echo "Current binary version: \"$VERSION\""

set_version "$VERSION"

commit_version "$VERSION"
git show HEAD

tag_version "$VERSION"
git tag -l

#push_changes
echo "Released GitHub \"$REPO\" with version: \"$VERSION\""
