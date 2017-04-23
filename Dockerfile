FROM nebo15/alpine-elixir:latest

# Maintainers
MAINTAINER Nebo#15 support@nebo15.com

# Configure environment variables and other settings
ENV MIX_ENV=prod \
    APP_NAME=trump_api \
    APP_PORT=4000

WORKDIR ${HOME}

# Install and compile project dependencies
COPY mix.* ./
RUN apk add --update make g++
RUN mix do deps.get
RUN mix deps.compile authable
RUN mix deps.compile

# Add project sources
COPY . .

# Compile project for Erlang VM
RUN mix do compile, release --verbose

# Change user to "default"
USER default

# Allow to read ENV vars for mix configs
ENV REPLACE_OS_VARS=true

# Change workdir to a released directory
WORKDIR /opt

# The command to run when this image starts up.
# To run migrations on start set DB_MIGRATE=true env when starting container.
CMD $APP_NAME/bin/$APP_NAME foreground
