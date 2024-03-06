# Start from the official Golang base image
FROM golang:alpine as builder

# Set the Current Working Directory inside the container
WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download

# Copy the source from the current directory to the Working Directory inside the container
COPY . .

# Build
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o discordbot .

# Start a new stage from scratch
FROM alpine:latest  

RUN apk --no-cache add ca-certificates

WORKDIR /root/

# Copy the binary file from the previous stage
COPY --from=builder /app/discordbot .

CMD ["./discordbot"]
