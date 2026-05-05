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

## 高风险命令

遇到以下行为应要求人工确认：

- 删除文件或目录。
- 重写 Git 历史。
- 推送、发布、部署。
- 访问生产数据库或云资源。
- 安装依赖或执行远程脚本。
