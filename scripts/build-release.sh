#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VERSION="$(tr -d '[:space:]' < "$ROOT/VERSION")"
PACKAGE_DIR="codex-config"
WORK_DIR="$(mktemp -d)"
DIST_DIR="$ROOT/dist"

cleanup() {
  rm -rf "$WORK_DIR"
}
trap cleanup EXIT

mkdir -p "$DIST_DIR" "$WORK_DIR/$PACKAGE_DIR"
cp -R "$ROOT/config-templates/"* "$WORK_DIR/$PACKAGE_DIR/"
cp "$ROOT/README.md" "$WORK_DIR/$PACKAGE_DIR/PROJECT-README.md"
cp "$ROOT/VERSION" "$WORK_DIR/$PACKAGE_DIR/VERSION"
cp "$ROOT/CHANGELOG.md" "$WORK_DIR/$PACKAGE_DIR/CHANGELOG.md"

(
  cd "$WORK_DIR"
  tar -czf "$DIST_DIR/codex-config-v$VERSION.tar.gz" "$PACKAGE_DIR"
)
cp "$DIST_DIR/codex-config-v$VERSION.tar.gz" "$DIST_DIR/codex-config.tar.gz"

echo "Built: $DIST_DIR/codex-config-v$VERSION.tar.gz"
echo "Built: $DIST_DIR/codex-config.tar.gz"
