FROM ruby:2.6
RUN apt-get update -qq && apt-get install -y nodejs
RUN mkdir /app
WORKDIR /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install
COPY . /app

CMD ["rails", "server", "-b", "0.0.0.0"]
