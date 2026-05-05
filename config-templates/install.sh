#!/usr/bin/env bash
set -euo pipefail

CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
mkdir -p "$CODEX_HOME"

if [[ -f "$CODEX_HOME/config.toml" ]]; then
  backup="$CODEX_HOME/config.toml.bak.$(date +%Y%m%d%H%M%S)"
  cp "$CODEX_HOME/config.toml" "$backup"
  echo "Backed up existing config to $backup"
fi

cp "$CONFIG_DIR/config.simple.toml" "$CODEX_HOME/config.toml"
echo "Installed $CODEX_HOME/config.toml"
echo "Review it before using custom providers or MCP servers."
