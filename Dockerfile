# 明示的にRubyバージョンを指定
FROM ruby:3.3.8-slim AS base

# 必要なパッケージをインストール
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    nodejs \
    libyaml-dev  # 追加: psychのビルドに必要

# アプリケーションディレクトリを作成
WORKDIR /App

# GemfileとGemfile.lockをコピー
COPY Gemfile /App/Gemfile
COPY Gemfile.lock /App/Gemfile.lock

# gemをインストール
RUN bundle install

# アプリケーションのソースコードをコピー
COPY . /App

# エントリポイントスクリプトをコピーして実行権限を付与
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# ポート3000を公開
EXPOSE 3000

# デフォルトコマンド
CMD ["rails", "server", "-b", "0.0.0.0"]