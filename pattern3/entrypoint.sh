#!/bin/sh
set -e

if [ -z "$GITHUB_REPOSITORY_URL" ]; then
  echo "GITHUB_REPOSITORY_URL is not set" >&2
  exit 1
fi

if [ -z "$GITHUB_PAT_TOKEN" ]; then
  echo "GITHUB_PAT_TOKEN is not set" >&2
  exit 1
fi

# Extract owner/repo from URL (supports https://github.com/owner/repo(.git))
repo_path=$(echo "$GITHUB_REPOSITORY_URL" | sed -e 's|^https://github.com/||' -e 's|^git@github.com:||' -e 's|\.git$||')
owner=$(echo "$repo_path" | cut -d'/' -f1)
repo=$(echo "$repo_path" | cut -d'/' -f2)

if [ -z "$owner" ] || [ -z "$repo" ]; then
  echo "Unable to parse owner/repo from GITHUB_REPOSITORY_URL: $GITHUB_REPOSITORY_URL" >&2
  exit 1
fi

api_url="https://api.github.com/repos/$owner/$repo/tarball"

cd /workspace

rm -rf repo
mkdir -p repo

# Download tarball via GitHub API with Authorization header and extract into repo
curl -sSL -H "Authorization: token $GITHUB_PAT_TOKEN" "$api_url" | tar xz --strip-components=1 -C repo

echo "Repository extracted to /workspace/repo"
ls -la repo
