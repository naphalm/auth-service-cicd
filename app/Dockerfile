# ------------------------------
# Builder stage
# ------------------------------
FROM golang:1.22-alpine AS builder

WORKDIR /app


# Install git + ca-certificates for dependencies
RUN apk add --no-cache git ca-certificates

# Copy Go modules and download dependencies
COPY go.mod go.sum ./
RUN go mod download

# Copy app source
COPY . .

# Build Go binary
RUN CGO_ENABLED=0 GOOS=linux go build -o auth-service

# Copy migration script and make it executable
COPY scripts/migrate.sh /app/migrate.sh
RUN chmod +x /app/migrate.sh

# ------------------------------
# Final stage
# ------------------------------
FROM alpine:3.19

WORKDIR /app

# Install bash + postgresql client (needed for migrations if using psql)
RUN apk add --no-cache bash postgresql-client

# Copy binary and migration script from builder
COPY --from=builder /app/auth-service .
COPY --from=builder /app/migrate.sh .

# Expose port
EXPOSE 3000

# Default user
USER 1000:1000

# Run migrations first, then start the Go service
ENTRYPOINT ["sh", "-c", "/app/migrate.sh && /app/auth-service"]
