# Start from the official Golang base image
FROM golang:alpine as builder

# Container workdir
WORKDIR /app

COPY go.mod go.sum ./

# Dependencies
RUN go mod download

# Copy from current dir to workdir in container
COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o dz-bot .


# Start a new stage from scratch
FROM alpine:latest

RUN apk --no-cache add ca-certificates

WORKDIR /root/


COPY --from=builder /app/dz-bot .

CMD ["sh", "-c", "./dz-bot -t $TOKEN"]
