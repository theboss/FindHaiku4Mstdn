FROM ruby:2.4.4-stretch

RUN apt-get update \
  && apt-get install git mecab libmecab-dev mecab-ipadic-utf8 make curl xz-utils file sudo -y \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /opt
RUN git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git \
    && cd /opt/mecab-ipadic-neologd \
    && ./bin/install-mecab-ipadic-neologd -n -y \
    && rm -rf /opt/mecab-ipadic-neologd \
    && echo "dicdir = /usr/lib/x86_64-linux-gnu/mecab/dic/mecab-ipadic-neologd/" > /etc/mecabrc

# install app
RUN mkdir /app
COPY . /app
WORKDIR /app
RUN bundle install
ENV RUBYOPT -EUTF-8
CMD bundle exec ruby main.rb