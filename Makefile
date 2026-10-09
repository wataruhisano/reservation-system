.PHONY: fmt fmt-check vet lint test test-race run check

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

# Run every check that CI runs.
check: fmt-check vet lint test test-race
