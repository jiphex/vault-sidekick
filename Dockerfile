FROM golang:1-alpine as GOBUILD
ARG GOPROXY=https://proxy.golang.org
COPY . /work
WORKDIR /work
RUN apk --no-cache add git make && make

FROM alpine:latest
MAINTAINER Rohith <gambol99@gmail.com>
COPY --from=GOBUILD /work/bin/vault-sidekick /vault-sidekick
RUN apk --no-cache add ca-certificates && \
  adduser -D vault && \
  chmod 755 /vault-sidekick
USER vault

ENTRYPOINT [ "/vault-sidekick", "-logtostderr", "-v", "10"]
