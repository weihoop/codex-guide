# Execpolicy 权限规则

Codex CLI 除了 `sandbox_mode` 和 `approval_policy`，还可以用 execpolicy rules 对具体命令做前缀匹配决策。

## 三种决策

| decision | 含义 | 适合命令 |
| --- | --- | --- |
| `allow` | 允许执行，不再反复确认 | 只读查询、本地测试、lint、build |
| `prompt` | 执行前询问用户 | 删除、移动、安装依赖、推送、远程访问 |
| `forbidden` | 直接阻止 | 系统级破坏、磁盘格式化、不可逆删除 |

> 注意：本机 `codex execpolicy check` 验证到有效值是 `allow`、`prompt`、`forbidden`，不是其他工具常见的 `deny`。

## 规则格式

```python
prefix_rule(pattern=["git", "status"], decision="allow")
prefix_rule(pattern=["rm"], decision="prompt")
prefix_rule(pattern=["dd"], decision="forbidden")
```

规则按命令 token 前缀匹配。比如 `pattern=["git", "status"]` 会匹配 `git status --short`。

## 推荐策略

- `allow` 大部分低风险本地操作：`rg`、`sed`、`cat`、`git diff`、`npm run test`。
- `prompt` 可恢复但有副作用的操作：`rm`、`git push`、`npm install`、`curl`、`docker`。
- `forbidden` 明显危险或系统级破坏操作：`dd`、`mkfs`、`rm -rf /`、`terraform destroy`。

这样可以减少“总让我 yes 确认”的打扰，同时保留关键风险点的人类确认。

## 验证规则

```bash
codex execpolicy check --rules config-templates/rules/default.rules --pretty git status
codex execpolicy check --rules config-templates/rules/default.rules --pretty rm file.txt
codex execpolicy check --rules config-templates/rules/default.rules --pretty dd if=/dev/zero of=/dev/disk0
```

本仓库提供批量检查：

```bash
python3 scripts/check_execpolicy.py
```

## 和 sandbox / approval 的关系

- `sandbox_mode` 决定文件系统和环境边界。
- `approval_policy` 决定什么时候需要用户批准。
- execpolicy rules 对具体 shell 命令再做 allow/prompt/forbidden 分类。

推荐日常组合：

```toml
sandbox_mode = "workspace-write"
approval_policy = "on-request"
```

再配合 `config-templates/rules/default.rules` 减少低风险命令确认。
