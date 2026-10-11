.PHONY: fmt fmt-check vet lint test test-race run check docker-build docker-run

# Format all Go files in place.
fmt:
	gofmt -w .

# Fail if any Go file is not gofmt-formatted (used by CI).
fmt-check:
	@files=$$(gofmt -l .); \
	if [ -n "$$files" ]; then \
		echo "These files need gofmt (run 'make fmt'):"; \
		echo "$$files"; \
		exit 1; \
	fi

vet:
	go vet ./...

lint:
	golangci-lint run ./...

test:
	go test ./...

test-race:
	go test -race ./...

run:
	go run ./cmd/api

# Run every Go check that CI runs (CI additionally runs docker-build).
check: fmt-check vet lint test test-race

IMAGE ?= reservation-system-api:dev

docker-build:
	docker build -t $(IMAGE) .

docker-run:
	docker run --rm -p 8080:8080 $(IMAGE)
