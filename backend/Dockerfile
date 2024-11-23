# ベースとなるイメージ
FROM ruby:3.1.3 as base
WORKDIR /app
ENV NODE_MAJOR_VERSION 18

# 各種ライブラリをインストール
FROM base AS builder
RUN curl -sL https://deb.nodesource.com/setup_$NODE_MAJOR_VERSION.x | bash - && \
   apt-get update -qq && \
   apt-get install -y --no-install-recommends \
   vim locales build-essential curl libpq-dev libmariadb-dev nodejs yarn nginx sudo default-mysql-client openssl

# bundle install
FROM builder as bundle
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install

# 最終的に使用するイメージ
FROM bundle as main
COPY . .

# railsの起動設定
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]

