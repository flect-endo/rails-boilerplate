# rails-boilerplate
Devise + cancancan + RSpecを使ったテンプレート用Railsアプリ

以下のひな形を含んでいます。

- OAuth を利用した Salesforce ログイン（それと別に通常フォームでのメールアドレスとパスワードによる認証も含む）
- Force.com Canvas 署名付きリクエストをデコードして認証を行う
- Devise + cancancan + Bootstrap の標準的なCRUD
- Ajax を使った非同期CSVファイルアップロード
- 外部サービス(Google Maps API)連携

## 準備

以下の環境変数をセットする

- ``SMTP_USER_NAME`` : Gmailユーザ名(メールアドレス)
- ``SMTP_PASSWORD`` : Gmailパスワード
- ``AUTH_CLIENT_KEY`` : OAuthコンシューマ鍵
- ``AUTH_CLIENT_SECRET`` : OAuthコンシューマの秘密
