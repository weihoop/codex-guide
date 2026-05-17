# 权限与沙箱

## Sandbox

| 模式 | 用途 |
| --- | --- |
| `read-only` | 只读探索和审查 |
| `workspace-write` | 日常开发，允许写工作区 |
| `danger-full-access` | 外部隔离环境中的特殊任务 |

## Approval

| 策略 | 用途 |
| --- | --- |
| `on-request` | 交互使用推荐 |
| `untrusted` | 陌生仓库或高风险代码 |
| `never` | CI/批处理，需要外部隔离 |
| `on-failure` | 旧策略，优先考虑其他选项 |

## 推荐组合

```bash
# 安全审查
codex --sandbox read-only --ask-for-approval on-request

# 日常开发
codex --sandbox workspace-write --ask-for-approval on-request

# CI
codex exec --ask-for-approval never
```

## 自动模式

如果希望 Codex 尽量自动执行命令，不反复请求人工确认，推荐先保留工作区沙箱：

```bash
codex --sandbox workspace-write --ask-for-approval never
```

这个组合允许 Codex 写当前工作区，但不会绕过文件系统沙箱。适合本地日常开发中相对可控的自动化。

非交互执行可使用：

```bash
codex exec --sandbox workspace-write --ask-for-approval never "根据当前改动更新文档"
```

也可以在 `~/.codex/config.toml` 中保存一个 profile：

```toml
[profiles.auto]
sandbox_mode = "workspace-write"
approval_policy = "never"
```

然后用：

```bash
codex --profile auto
```

`--dangerously-bypass-approvals-and-sandbox` 会同时跳过确认和沙箱，风险很高。只有在 Docker、临时 VM、一次性工作区等外部已隔离环境中才考虑使用。

## 高风险命令

遇到以下行为应要求人工确认：

- 删除文件或目录。
- 重写 Git 历史。
- 推送、发布、部署。
- 访问生产数据库或云资源。
- 安装依赖或执行远程脚本。
