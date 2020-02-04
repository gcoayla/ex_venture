FROM grapevinehaus/elixir:1.9.4-alpine-1 as builder

# The nuclear approach:
# RUN apk add --no-cache alpine-sdk
RUN apk add --no-cache \
    gcc \
    git \
    make \
    musl-dev

RUN mix local.rebar --force && \
    mix local.hex --force

WORKDIR /app
ENV MIX_ENV=prod
COPY mix.* /app/
RUN mix deps.get --only prod

RUN mix deps.compile

FROM node:10.9 as frontend

WORKDIR /app
COPY assets/package*.json /app/
COPY --from=builder /app/deps/phoenix /deps/phoenix
COPY --from=builder /app/deps/phoenix_html /deps/phoenix_html

RUN npm install -g yarn && yarn install

COPY assets /app
RUN npm run deploy

FROM builder as releaser
COPY --from=frontend /priv/static /app/priv/static
COPY . /app/
RUN mix deps.clean mime --build && \
  mix deps.compile mime && \
  mix deps.get && \
  mix phx.digest && \
  mix release

FROM alpine:3.11
RUN apk add -U bash libssl1.1
WORKDIR /app
COPY --from=releaser /app/_build/prod/rel/ex_venture /app/
COPY config/prod.docker.exs /etc/exventure.config.exs

EXPOSE 4000 5555 5556

VOLUME /var/log/ex_venture/

ENTRYPOINT ["bin/ex_venture"]
CMD ["start"]
