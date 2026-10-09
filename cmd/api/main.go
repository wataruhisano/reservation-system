package main

import (
	"log/slog"
	"net/http"
	"os"
	"time"

	"github.com/wataruhisano/reservation-system/internal/api"
)

func main() {
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	srv := &http.Server{
		Addr:    ":" + port,
		Handler: api.NewRouter(),
		// Connection-level limits. Per-request timeouts via context are
		// handled separately (Phase 3).
		ReadHeaderTimeout: 5 * time.Second,  // guards against Slowloris
		IdleTimeout:       60 * time.Second, // closes idle keep-alive connections
	}

	slog.Info("starting server", "addr", srv.Addr)
	// ListenAndServe always returns a non-nil error. Graceful shutdown is
	// added in Phase 3; until then, any return means the server failed.
	err := srv.ListenAndServe()
	slog.Error("server stopped", "error", err)
	os.Exit(1)
}
