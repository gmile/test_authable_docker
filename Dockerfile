FROM nebo15/alpine-elixir:latest
RUN apk add --update make g++

# Maintainers
MAINTAINER Eugene

# Configure environment variables and other settings
ENV MIX_ENV=prod \
    APP_NAME=test_authable_docker

WORKDIR ${HOME}

# Install and compile project dependencies
COPY mix.* ./

RUN mix deps.get
RUN mix deps.compile
RUN mix ecto.create
RUN mix ecto.migrate -r Authable.Repo

# Add project sources
COPY . .

# Compile project for Erlang VM
RUN mix do compile, release --verbose

# Allow to read ENV vars for mix configs
ENV REPLACE_OS_VARS=true

# Change workdir to a released directory
WORKDIR /opt

# The command to run when this image starts up.
# To run migrations on start set DB_MIGRATE=true env when starting container.
CMD $APP_NAME/bin/$APP_NAME foreground
