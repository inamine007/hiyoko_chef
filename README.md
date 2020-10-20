# ひよこシェフ
レシピの管理や共有ができるポートフォリオ作品です。
食材の登録から細かく設定ができ、その食材を元に簡単にレシピが作成できます。レシピの原価も計算してくれます。
作成したレシピは非公開、公開、または特定の範囲だけに公開することが可能です。
https://hiyoko-chef.com

# デモ


# 使用技術
- Ruby 2.6.3
- Ruby on Rails 6.0.3.2
- Vue.js 2.6.12
- Nuxt.js 2.14.4
- PostgreSQL
- AWS
* VPC
* EC2
* EKS
* RDS
* Route53
- Docker/Docker-compose
- Rspec

# インフラ構成図

# ER図

# 機能一覧
- ユーザー登録、ログイン、Googleソーシャルログイン(devise_token_auth,google_oauth2)
- 画像アップロード(active_storage,S3)
- レシピ投稿
- グループ
- 原価計算
- いいね、コメント、フォロー、メッセージ
- 検索

# テスト
- Rspec
* 機能テスト(request)