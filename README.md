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

### パターン1 — URL に PAT を含めて clone
- 特徴: `https://<token>@github.com/owner/repo.git` の形式で直接 git clone を実行する最も単純な方法。  
- 利点: 実装が簡単で追加ツール不要（git があれば動作）。  
- 欠点: トークンが `.git/config` に残る、プロセス引数やログに漏れるリスクがあり安全性が低い。  
- 推奨: テストや一時的な検証のみでの使用。運用環境や機密トークンでは使用しない。

### パターン2 — `http.extraheader` を用いた認証
- 特徴: `git -c "http.extraheader=AUTHORIZATION: basic <base64>" clone ...` のように一時的なヘッダを渡して clone する。  
- 利点: トークンを `.git/config` に残さず、コマンド固有の設定として扱えるため安全性が比較的高い。git の履歴やサブモジュール等、通常の git 操作が可能。  
- 欠点: 実行時にヘッダを組み立てるため若干の実装が必要。  
- 推奨: プライベートリポジトリを履歴ごと扱う（開発用途）場合の第一選択。バランスが良い。

### パターン3 — GitHub API からアーカイブを取得（curl + tar）
- 特徴: GitHub API (`/repos/:owner/:repo/tarball`) に Authorization ヘッダを付けてアーカイブ（tarball）を取得し展開する。  
- 利点: `.git` を持たないソースツリーのみが抽出され、トークンが git 履歴に残らない。シンプルで高速。  
- 欠点: Git のメタデータ（履歴、タグ、サブモジュール等）が得られない。特定ブランチ/コミットを指定する実装が必要になる場合がある。  
- 推奨: 履歴不要でソースのみ欲しい、または最小限の依存で取得したい場合に推奨。

### 共通の推奨事項（全パターン共通）
- トークンはビルド時に Dockerfile にハードコーディングしない。環境変数やランタイムのシークレット管理機能を使用する。  
- PAT の権限は必要最小限（例: private repo の読み取りのみ）に限定する。  
- コンテナ内ログやプロセス一覧にトークンが残らないよう注意する（特にパターン1）。  
- サブモジュールや履歴を必要とする場合は pattern2（git を使う方法）を優先する。  
- 自動化環境では CI/CD のシークレットマネージャー（GitHub Actions Secrets, GitLab CI/CD variables 等）を利用する。
