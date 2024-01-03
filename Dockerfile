FROM golang:1.20 as builder

WORKDIR /go/src/github.com/sebastiavillalobos/test-123

COPY go.mod go.sum ./

RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -o /go/bin/test-123

FROM alpine:3.19

COPY --from=builder /go/bin/test-123 /test-123

RUN addgroup -S go-app && adduser -S go-app -G go-app

RUN chown go-app:go-app /test-123

USER go-app

ENTRYPOINT ["/test-123"]

EXPOSE 8181
