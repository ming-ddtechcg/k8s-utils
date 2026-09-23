FROM golang:1.16-alpine AS build

RUN apk add --no-cache git

WORKDIR /src 

COPY go.mod ./
COPY go.sum ./

RUN go mod download

COPY consumer.go ./

RUN go build consumer.go

FROM alpine AS runtime

COPY --from=build /src/consumer /app/consumer

CMD [ "/app/consumer" ]
