# syntax=docker/dockerfile:1

FROM golang:1.17.3-alpine AS build

WORKDIR /fizzbuzz

COPY go.mod .
COPY go.sum .

RUN go mod download

COPY cmd ./cmd
COPY lib ./lib
COPY templates ./templates
COPY main.go .

RUN CGO_ENABLED=0 go build -o ./fizzbuzz

FROM gcr.io/distroless/base-debian10

COPY --from=build /fizzbuzz/fizzbuzz /fizzbuzz
COPY templates /templates

CMD ["/fizzbuzz", "serve"]

