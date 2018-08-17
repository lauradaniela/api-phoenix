FROM elixir:1.6.0
ENV DEBIAN_FRONTEND=noninteractive

# Install hex
RUN mix local.hex --force

# Install rebar
RUN mix local.rebar --force

# Install the Phoenix framework itself
RUN mix archive.install --force https://github.com/phoenixframework/archives/raw/master/phx_new.ez

# Install NodeJS 6.x and the NPM
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install -y -q nodejs

RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main" > /etc/apt/sources.list.d/pgdg.list
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get update
RUN apt-get install -y postgresql-client-9.4

RUN apt-get install -y inotify-tools

# Install Elixir Deps
ADD mix.* ./
RUN MIX_ENV=prod mix local.rebar
RUN MIX_ENV=prod mix local.hex --force
RUN MIX_ENV=prod mix deps.get

# Set /app as workdir
RUN mkdir /app
ADD . /app
WORKDIR /app

RUN MIX_ENV=prod mix compile

#Compile assets
RUN MIX_ENV=prod mix phx.digest

#Exposes this port from the docker container to the host machine
EXPOSE 4000

#The command to run when this image starts up
CMD MIX_ENV=prod mix ecto.migrate && \
  MIX_ENV=prod mix phx.server
