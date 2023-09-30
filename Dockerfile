FROM golang:alpine AS builder

ARG TARGETPLATFORM=linux/amd64
ARG TARGETOS=linux
ARG TARGETARCH=amd64

WORKDIR /build
RUN --mount=target=/build,rw \
    go mod tidy && \
    CGO_ENABLED=0 GOOS=$TARGETOS GOARCH=$TARGETARCH go build -a -ldflags="-s -w" && \
    cp -a /build/app /build/tinygraphs /tmp

FROM --platform=$TARGETPLATFORM scratch

COPY --from=builder /tmp/app/generator /app
COPY --from=builder /tmp/tinygraphs /app/tinygraphs

ENV PORT=9090
EXPOSE 9090

ENTRYPOINT ["/app/tinygraphs"]
