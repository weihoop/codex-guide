# 自动化与 CI

## 使用 `codex exec`

```bash
codex exec "根据 git diff 生成 PR 摘要"
codex exec --sandbox read-only "审查当前分支安全风险"
```

## CI 原则

- 使用临时容器或隔离 runner。
- 不提供生产密钥。
- `--ask-for-approval never` 只用于可失败、可回滚任务。
- 输出结果要进入构建日志或 artifact。

## 适合自动化的任务

- 文档索引更新。
- 变更摘要。
- 代码审查草稿。
- 测试失败归因。
- changelog 草稿。
