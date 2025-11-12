#!/usr/bin/env bash
set -euo pipefail

# update-gt-formula.sh
# Usage: ./scripts/update-gt-formula.sh v1.0.12
#
# Downloads the tar.gz for the provided tag from the gittool repo,
# computes the sha256 and updates Formula/gt.rb (url and sha256).

REPO_OWNER="ElaraDevSolutions"
REPO_NAME="gittool"
FORMULA_PATH="Formula/gt.rb"

# Defaults
COMMIT=true
PUSH=false

if [ "$#" -lt 1 ]; then
  echo "Usage: $0 [--no-commit] [--push] <tag>   (example: $0 v1.0.12)"
  exit 2
fi

# simple arg parse
TAG=""
for arg in "$@"; do
  case "$arg" in
    --no-commit)
      COMMIT=false
      ;;
    --push)
      PUSH=true
      ;;
    --help|-h)
      echo "Usage: $0 [--no-commit] [--push] <tag>"
      exit 0
      ;;
    *)
      if [ -z "$TAG" ]; then
        TAG="$arg"
      else
        echo "Unknown extra argument: $arg" >&2
        exit 2
      fi
      ;;
  esac
done

if [ -z "$TAG" ]; then
  echo "Missing tag argument" >&2
  echo "Usage: $0 [--no-commit] [--push] <tag>"
  exit 2
fi

TARBALL_URL="https://github.com/${REPO_OWNER}/${REPO_NAME}/archive/refs/tags/${TAG}.tar.gz"

TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

TARBALL="$TMPDIR/${REPO_NAME}-${TAG}.tar.gz"

echo "Downloading ${TARBALL_URL} to ${TARBALL}..."
curl -L -o "$TARBALL" "$TARBALL_URL"

echo "Computing sha256..."
SHA256=$(shasum -a 256 "$TARBALL" | awk '{print $1}')

echo "New sha256: $SHA256"

if [ ! -f "$FORMULA_PATH" ]; then
  echo "Formula file $FORMULA_PATH not found. Run this script from the repo root." >&2
  exit 1
fi

BACKUP="${FORMULA_PATH}.bak-$(date +%Y%m%d%H%M%S)"
cp "$FORMULA_PATH" "$BACKUP"
echo "Backup of formula written to $BACKUP"


echo "Updating url, sha256 and version in $FORMULA_PATH..."

# derive version from tag (strip leading v if present)
VERSION=${TAG#v}

# Use awk to rewrite the file in a robust way: replace or insert url, sha256 and version lines
awk -v url_line="  url \"${TARBALL_URL}\"" \
    -v sha_line="  sha256 \"${SHA256}\"" \
    -v ver_line="  version \"${VERSION}\"" \
    'BEGIN{url_done=0;sha_done=0;ver_done=0} \
    { \
      if ($0 ~ /^[[:space:]]*url[[:space:]]+".*"[[:space:]]*$/) { print url_line; url_done=1; next } \
      if ($0 ~ /^[[:space:]]*sha256[[:space:]]+"[a-f0-9]{64}"[[:space:]]*$/) { print sha_line; sha_done=1; next } \
      if ($0 ~ /^[[:space:]]*version[[:space:]]+".*"[[:space:]]*$/) { print ver_line; ver_done=1; next } \
      print $0; \
    } END{ if(!url_done) print url_line > "/dev/stderr"; if(!sha_done) print sha_line > "/dev/stderr"; if(!ver_done) print ver_line > "/dev/stderr" }' \
    "$BACKUP" > "$FORMULA_PATH.tmp"

# If awk printed missing lines to stderr the above will still succeed; we now ensure the tmp file exists
if [ ! -f "$FORMULA_PATH.tmp" ]; then
  echo "Failed to produce updated formula file" >&2
  exit 1
fi

# Move tmp into place
mv "$FORMULA_PATH.tmp" "$FORMULA_PATH"

echo
echo "Updated $FORMULA_PATH with:"
echo "  url: $TARBALL_URL"
echo "  sha256: $SHA256"
echo "  version: $VERSION"

echo
echo "Diff against backup (for review):"
diff -u "$BACKUP" "$FORMULA_PATH" || true

echo
if [ "$COMMIT" = true ]; then
  echo
  echo "Committing changes..."
  git add "$FORMULA_PATH"
  git commit -m "gt: update to ${TAG}" || echo "No changes to commit or commit failed"
  if [ "$PUSH" = true ]; then
    echo "Pushing to origin..."
    git push
  else
    echo "Changes committed locally. Run 'git push' when ready."
  fi
else
  echo
  echo "COMMIT disabled. Review the diff, then commit manually:" 
  echo "  git add $FORMULA_PATH && git commit -m 'gt: update to ${TAG}'"
fi

echo
echo "Testing notes: ensure the repo is a Homebrew tap (name like <user>/homebrew-tools) and pushed to GitHub."
echo "To test locally without pushing, you can run:" 
echo "  brew tap --custom-remote ${REPO_OWNER}/homebrew-tools \"$(pwd)\""
echo "  brew install ${REPO_OWNER}/homebrew-tools/gt"

exit 0
