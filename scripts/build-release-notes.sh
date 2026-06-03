#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VERSION="$(tr -d '[:space:]' < "$ROOT/VERSION")"

cat <<EOF
## 安装

安装最新 Release：

\`\`\`bash
wget https://github.com/weihoop/codex-guide/releases/latest/download/codex-config.tar.gz
tar -xzf codex-config.tar.gz
cd codex-config
bash install.sh
\`\`\`

安装当前版本：

\`\`\`bash
wget https://github.com/weihoop/codex-guide/releases/download/v$VERSION/codex-config-v$VERSION.tar.gz
tar -xzf codex-config-v$VERSION.tar.gz
cd codex-config
bash install.sh
\`\`\`

## 变更记录

EOF

awk 'NR == 1 && $0 == "# Changelog" { next } NR == 2 && $0 == "" { next } { print }' "$ROOT/CHANGELOG.md"
