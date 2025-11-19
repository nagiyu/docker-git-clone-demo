#!/bin/sh
set -e

if [ -z "$GITHUB_REPOSITORY_URL" ]; then
  echo "GITHUB_REPOSITORY_URL is not set" >&2
  exit 1
fi

# Build auth URL if token provided
repo_url="$GITHUB_REPOSITORY_URL"
if [ -n "$GITHUB_PAT_TOKEN" ]; then
  case "$repo_url" in
    https://*)
      auth_url=$(echo "$repo_url" | sed -e "s|^https://|https://$GITHUB_PAT_TOKEN@|")
      ;;
    *)
      auth_url="$repo_url"
      ;;
  esac
else
  auth_url="$repo_url"
fi

cd /work

rm -rf repo
git clone "$auth_url" repo
ls -la repo
