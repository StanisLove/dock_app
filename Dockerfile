FROM ruby:2.6.4

RUN curl -sL https://deb.nodesource.com/setup_11.x | bash -
RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
      && echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list

RUN curl -sL https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
      && RELEASE=$(lsb_release -cs) \
      && echo "deb http://apt.postgresql.org/pub/repos/apt/ ${RELEASE}-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
      && cat /etc/apt/sources.list.d/pgdg.list

RUN apt-get update -qq \
      && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
      postgresql-client-11 \
      nodejs \
      yarn=1.17.3-1

RUN mkdir /app
WORKDIR /app

COPY . /app/

ENV GEM_HOME=/bundle
ENV BUNDLE_PATH $GEM_HOME

RUN gem install bundler --version=2.0.2

RUN bundle install

RUN yarn install

EXPOSE 3000

CMD ["rails", "s", "-b", "0.0.0.0", "-p", "3000"]
