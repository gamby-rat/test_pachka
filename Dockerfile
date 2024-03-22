FROM ruby:3.1.4-slim

RUN apt-get update -qq && \
    apt-get install -y \
    default-libmysqlclient-dev \
    build-essential \
    libpq-dev 

WORKDIR /app

COPY . . 

RUN bundle install

EXPOSE 4567

CMD ["ruby", "app.rb", "-o", "0.0.0.0"]
