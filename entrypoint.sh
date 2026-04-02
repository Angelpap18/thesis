#!/bin/bash
set -e

# ── Config dir ────────────────────────────────────────────
CONFIG_DIR="/home/op/.config/opencode"
mkdir -p "$CONFIG_DIR"

# ── Resolve variables ─────────────────────────────────────
MODEL="${MODEL:-deepseek-r1:70b}"
OLLAMA_PORT="${OLLAMA_PORT:-11434}"
BASE_URL="http://ollama:${OLLAMA_PORT}/v1"

echo ">>> OpenCode starting with model: ${MODEL}"
echo ">>> Ollama base URL: ${BASE_URL}"

# ── Generate opencode.json at runtime ────────────────────
cat > "$CONFIG_DIR/config.json" <<EOF
{
  "\$schema": "https://opencode.ai/config.json",
  "provider": {
    "ollama": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "Ollama (local)",
      "options": {
        "baseURL": "${BASE_URL}"
      },
      "models": {
        "${MODEL}": {
          "name": "${MODEL}",
          "tools": true
        }
      }
    }
  },
  "model": "ollama/${MODEL}"
}
EOF

echo ">>> Config written to ${CONFIG_DIR}/config.json"
cat "$CONFIG_DIR/config.json"

# ── Launch OpenCode ───────────────────────────────────────
exec opencode
