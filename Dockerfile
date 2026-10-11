# ---- Build stage: compile a static binary with the Go toolchain ----
FROM golang:1.27.1 AS build
WORKDIR /src

# Copy module files first so the dependency layer is cached
# when only source code changes.
COPY go.mod go.sum* ./
RUN go mod download

# Copy only the source needed to build the API.
COPY cmd/ cmd/
COPY internal/ internal/
RUN CGO_ENABLED=0 go build -trimpath -o /out/api ./cmd/api

# ---- Run stage: minimal image with only the binary ----
# distroless/static: CA certificates and tzdata, no shell or package manager.
# :nonroot runs as an unprivileged user (UID 65532).
FROM gcr.io/distroless/static-debian13:nonroot
COPY --from=build /out/api /api
EXPOSE 8080
ENTRYPOINT ["/api"]
