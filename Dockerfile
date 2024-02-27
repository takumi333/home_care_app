FROM ruby:3.3.0
# 最新パッケージを取得・ログ冗長化防止 & node.jsインストール
RUN apt-get update -qq && apt-get install -y nodejs

RUN mkdir /app
WORKDIR /app

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
COPY package.json /app/package.json

RUN gem install bundler
RUN bundle install
RUN npm install

COPY . /app

CMD ["rails", "server", "-b", "0.0.0.0"]
