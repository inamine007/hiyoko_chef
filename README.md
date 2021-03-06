# ひよこシェフ
レシピの管理や共有ができるポートフォリオ作品です。
食材の登録から細かく設定ができ、その食材を元に簡単にレシピが作成できます。レシピの原価も計算してくれます。
作成したレシピは非公開、公開、または特定の範囲だけに公開することが可能です。
https://hiyoko-chef.com
ゲストログイン email: test3@example.com　password: 111111
<img width="1434" alt="ひよこトップ" src="https://user-images.githubusercontent.com/60652558/96622113-7ebdbd80-1344-11eb-97b5-34e573e4bc1c.png">

# デモ
<img src="https://user-images.githubusercontent.com/60652558/96623072-c264f700-1345-11eb-964d-0d44cce6d828.gif" width="1400">

# 使用技術
- Ruby 2.6.3
- Ruby on Rails 6.0.3.2
- Vue.js 2.6.12
- Nuxt.js 2.14.4
- PostgreSQL
- Docker/Docker-compose
- Rspec
#### AWS
- VPC
- EC2
- EKS
- CloudFront
- RDS
- Route53

# インフラ構成図
![インフラ構成図 (3)](https://user-images.githubusercontent.com/60652558/96624776-2ee0f580-1348-11eb-9d94-185faa15500c.png)

# ER図
![ER図 (3)](https://user-images.githubusercontent.com/60652558/96624831-4ae49700-1348-11eb-9a93-d23828826ffa.png)

# 機能一覧
- ユーザー登録、ログイン、Googleソーシャルログイン(devise_token_auth,google_oauth2)
- 画像アップロード(active_storage,S3)
- レシピ投稿
- グループ
- 原価計算
- いいね、コメント、フォロー、メッセージ
- 検索

# テスト
#### Rspec
- 機能テスト(request)
