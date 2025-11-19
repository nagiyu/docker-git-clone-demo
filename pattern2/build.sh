#!/bin/sh
set -e

# プロジェクト直下から実行
# sh pattern2/build.sh
docker build -t docker-git-clone-demo:pattern2 ./pattern2
