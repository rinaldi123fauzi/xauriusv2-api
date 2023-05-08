FROM ruby:3.1.2

ARG BUNDLER_VERSION=2.3.26

# Install yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg -o /root/yarn-pubkey.gpg && apt-key add /root/yarn-pubkey.gpg
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y --no-install-recommends nodejs yarn

# Default directory
ENV INSTALL_PATH /web
RUN mkdir -p $INSTALL_PATH

# Upgrade RubyGems and install required Bundler version
RUN gem update --system
RUN gem install bundler:$BUNDLER_VERSION
ENV BUNDLER_VERSION=$BUNDLER_VERSION

# Install gems
WORKDIR $INSTALL_PATH
COPY . .
RUN rm -rf node_modules vendor
RUN gem install rails bundler
RUN bundle install
RUN yarn install

EXPOSE 3000

RUN chmod +x /web/start.sh
ENTRYPOINT "/web/start.sh"