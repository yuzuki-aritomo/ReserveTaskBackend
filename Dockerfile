FROM ruby:3.0.2

# 必要なパッケージのインストール（Rails6からWebpackerがいるので、yarnをインストールする）
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
        && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
        && apt-get update -qq \
        && apt-get install -y build-essential libpq-dev nodejs yarn

#timezoneの設定
ENV TZ Asia/Tokyo

# 作業ディレクトリの作成
RUN mkdir /rails-app
WORKDIR /rails-app

# ホスト側（ローカル）（左側）のGemfileを、コンテナ側（右側）のGemfileへ追加
ADD ./Gemfile /rails-app/Gemfile
ADD ./Gemfile.lock /rails-app/Gemfile.lock

# Gemfileのbundle install
RUN bundle install
ADD . /rails-app