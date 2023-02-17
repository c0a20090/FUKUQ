# FUKUQ

## サイトURL

https://fukuq.onrender.com/

## サイト概要

気になっている服のブランドが分からない人や服に関する質問をしたい人が、気軽に質問・回答ができるQ%Aサイトです。

## サイトテーマ

服に関する質問をするサイトということで、FUKUのQ&AでFUKUQ

## 制作背景

私はファッションが好きでSNSのインフルエンサーを参考にすることが多いのですが、その際に気になった服のブランド名がわからない、コメント欄で聞いてもあまり返信は帰ってこない、という問題がありました。<br>
そこで、**''同じ悩みを持つ服が好きな方々を支援したい、皆で知識を共有したいと思い、このテーマを選定しました。''**
また、Railsを学習したので、そのアウトプットとしてなにかしらアプリを作りたいと思い、このFUKUQを開発しました。

## ターゲットユーザー

* 服が好きな方
* 普段服を探していて、ブランドが分からなくて困っている方

## 主な利用シーン

* 気になった服のブランド名が分からない時。など

## 工夫した点

* 服のジャンルごとにタグ分けすることで、自分の知りたい質問や答えてほしい質問を絞り込みやすくした。


# 実装機能一覧

|  | 機能 | gem/備考  |
|:---:|:---|:---|
| 1 |ユーザー/管理者(ログイン機能) | 無 |
| 2 |ゲストログイン機能| 無 |
| 3 |マイページ機能 | 無 |
| 4 |質問機能 | 無 |
| 5 |回答機能 | 無 |
| 6 |検索機能 | ransack |
| 7 |フォロー機能 | Hotwire(SPA化) |
| 8 |タグ機能 | 無 |
| 9 |Twitterシェア機能 | 無 |
| 10 |ページネーション機能 | kaminari |
| 11 |レスポンシブ対応 | Bootstrap |
| 12 |コード解析 | Rubocop |
| 13 |単体・統合テスト | RSpec |
| 14 |デプロイ | Render.com |

## 開発環境

* Ruby 3.1.2・Ruby on Rails 7.0.4・Bootstrap 3.4.1・sqlite3 1.4.2

* Docker+VSCode(Remote Container)

# 使用方法

```
$ git clone https://github.com/c0a20090/FUKUQ.git
$ cd FUKUQ/
$ bundle install --without production
$ rails db:migrate
$ rails s

```

## 利用方法

一般ユーザーの方は新規登録、もしくはゲストログインをご利用ください。