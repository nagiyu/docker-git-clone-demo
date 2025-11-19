# Docker GitHub Clone Demo

本プロジェクトは、Docker コンテナ内で GitHub のプライベートリポジトリをクローンする方法を検証するものです。

## 要件

- 各種設定は環境変数に保持する
- Docker コンテナに求める動作は下記
    - GitHub のプライベートリポジトリをクローンする
    - 対象リポジトリの直下にあるディレクトリ、ファイル一覧を表示する (e.g. `ls`)

## 共通設定

### 環境変数

- **GITHUB_REPOSITORY_URL**: GitHub のプライベートリポジトリの URL
- **GITHUB_PAT_TOKEN**: GitHub の PAT トークン

### Docker コンテナ

- **イメージ**: debian:13-slim

### スクリプト

- **build.sh**: 該当パターンの Dockerfile をビルドするスクリプト
- **run.sh**: 該当パターンの Docker コンテナを起動するスクリプト

各スクリプトは、本プロジェクトの直下から実行できる形式にします。

```bash
# ビルド
sh pattern1/build.sh

# 実行
sh pattern1/run.sh
```

## フォルダ構成

各パターンごとのディレクトリ配下に配置するファイル

```
|
+-- Dockerfile
|
+-- .env
|
+-- build.sh
|
+-- run.sh
```

## 各パターン

- **パターン1**: URL に PAT トークンを含む
