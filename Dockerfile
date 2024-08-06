# Build stage
FROM golang:1.22.5 AS builder

WORKDIR /app

# Copy only the go.mod file if go.sum is not present
COPY go.mod ./
RUN go mod download

COPY . .
RUN go build -o /app/main .

# Final stage - distroless image
FROM gcr.io/distroless/base

COPY --from=builder /app/main /main
COPY --from=builder /app/static /static

EXPOSE 8080

CMD ["/main"]
