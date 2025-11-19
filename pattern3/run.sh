#!/bin/sh
set -e

# プロジェクト直下から実行
# sh pattern3/run.sh

ENV_FILE="./pattern3/.env"

if [ ! -f "$ENV_FILE" ]; then
  echo ".env not found: $ENV_FILE" >&2
  exit 1
fi

docker run --rm --env-file "$ENV_FILE" docker-git-clone-demo:pattern3
