#!/bin/sh
set -e

# プロジェクト直下から実行
# sh pattern1/build.sh
docker build -t docker-git-clone-demo:pattern1 ./pattern1
