package api

import "net/http"

// NewRouter returns the HTTP handler with all API routes registered.
func NewRouter() http.Handler {
	mux := http.NewServeMux()
	mux.HandleFunc("GET /health", handleHealth)
	return mux
}
