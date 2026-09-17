# メモアプリ

メモを登録、表示、編集、削除できる Sinatra アプリケーションです。

## 必要なもの

- Ruby 4.0.6
- Bundler 4.0.17
- PostgreSQL 18.6 (Debian 18.6-1.pgdg13+2)

## セットアップ
アプリケーションのコードは `DB-connect` ブランチにあります。ブランチを指定してクローンしてください。

```sh
git clone -b DB-connect https://github.com/wnakamizo/fbc_sinatra_memo_app.git
cd fbc_sinatra_memo_app
```

続いて、依存する gem をインストールします。

```sh
bundle install
```

初回のみ、以下のコマンドを実行してデータベースとテーブルを作成してください。

```sh
ruby bin/setup_db.rb
```

## 起動方法

```sh
bundle exec ruby app.rb
```

起動後、ブラウザで <http://localhost:4567/> を開きます。

## データ保存

メモのデータは PostgreSQL の `memos` データベースに保存します。
