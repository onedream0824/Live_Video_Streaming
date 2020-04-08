FROM golang:latest as builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o livego .

FROM alpine:latest
LABEL maintainer="Ruben Cid Lara <rubencidlara@gmail.com>"
RUN mkdir -p /app/config
WORKDIR /app
ENV RTMP_PORT 1935
ENV HTTP_FLV_PORT 7001
ENV HLS_PORT 7002
ENV HTTP_OPERATION_PORT 8090
COPY --from=builder /app/config ./config
COPY --from=builder /app/livego .
EXPOSE ${RTMP_PORT}
EXPOSE ${HTTP_FLV_PORT}
EXPOSE ${HLS_PORT}
EXPOSE ${HTTP_OPERATION_PORT}
ENTRYPOINT ["./livego"]
