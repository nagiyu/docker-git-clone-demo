#!/bin/sh
set -e

# プロジェクト直下から実行
# sh pattern3/build.sh
docker build -t docker-git-clone-demo:pattern3 ./pattern3
