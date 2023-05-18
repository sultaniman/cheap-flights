FROM elixir:1.14.3-alpine as builder

WORKDIR /build
COPY . .
ENV MIX_ENV=runtime
ENV PORT=8080
RUN mix local.rebar --force \
    && mix local.hex --force \
    && mix deps.get \
    && mix release

# ---
FROM alpine:latest

WORKDIR /app
RUN apk add --no-cache --update bash openssl \
    && apk add --no-cache libgcc libstdc++

COPY --from=builder /build/_build/runtime/rel/cheap_flights/ .
ENV PORT=8080
EXPOSE ${ENV}
CMD ["/app/bin/cheap_flights", "start"]
