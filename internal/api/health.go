package api

import (
	"encoding/json"
	"log/slog"
	"net/http"
)

type healthResponse struct {
	Status string `json:"status"`
}

// handleHealth is a liveness check: it reports that the process is up and
// serving HTTP. It intentionally does not check dependencies such as the DB,
// so that a DB outage does not cause the orchestrator to restart the API.
func handleHealth(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	if err := json.NewEncoder(w).Encode(healthResponse{Status: "ok"}); err != nil {
		// The status line is already sent, so the error can only be logged.
		slog.ErrorContext(r.Context(), "failed to write health response", "error", err)
	}
}
