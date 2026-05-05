# Python/Shell 项目 AGENTS 模板

```markdown
# AGENTS.md

## Project

Python 和 Shell 自动化项目。

## Commands

- Test: `pytest`
- Format check: `ruff format --check .`
- Lint: `ruff check .`

## Rules

- Shell 脚本使用 `set -euo pipefail`。
- 不在日志中输出密钥。
- 生产命令先 dry-run 或只读检查。
- 修改脚本后给出回滚方式。
```
