#!/bin/sh
set -e

if [ -z "$GITHUB_REPOSITORY_URL" ]; then
  echo "GITHUB_REPOSITORY_URL is not set" >&2
  exit 1
fi

cd /work

# clean previous clone
rm -rf repo

if [ -n "$GITHUB_PAT_TOKEN" ]; then
  echo "Using http.extraheader for authentication"
  auth_header=$(printf 'x-access-token:%s' "$GITHUB_PAT_TOKEN" | base64 | tr -d '\n')
  git -c "http.extraheader=AUTHORIZATION: basic $auth_header" clone "$GITHUB_REPOSITORY_URL" repo
else
  git clone "$GITHUB_REPOSITORY_URL" repo
fi

ls -la repo
