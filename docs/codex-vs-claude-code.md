# Claude Code vs Codex

## 是否应该合并两个文档仓库？

建议不做物理合并，保留：

- `claude-code-guide`：Claude Code 中文手册。
- `codex-guide`：ChatGPT Codex / Codex CLI 中文手册。

可以互相链接，但内容应独立维护。

## 为什么不合并

| 维度 | Claude Code | Codex |
| --- | --- | --- |
| 项目指令 | `CLAUDE.md` | `AGENTS.md` |
| 用户配置 | `.claude/settings*.json` | `~/.codex/config.toml` |
| 权限表达 | allow/deny/ask 等工具权限 | sandbox + approval policy |
| 扩展入口 | Commands、Hooks、MCP、Skills | CLI、MCP、Plugins、Skills、App/IDE/Web |
| 非交互 | Claude Code CLI 语义 | `codex exec`、`codex review`、`codex apply` |
| 文档风险 | Anthropic 语义 | OpenAI/Codex 语义 |

简单替换产品名会造成错误示例，尤其是权限、安全和配置部分。

## 可以复用什么

- 文档架构：README、基础、进阶、安全、最佳实践、配置模板、Skills、资源索引。
- 写作方式：中文、实战导向、命令优先、检查清单。
- 团队实践：先计划、再执行、验证后总结。

## 必须重写什么

- 安装命令。
- 配置文件格式。
- 权限模型。
- slash/custom command 机制。
- Hooks 说明。
- Skills/Plugins/MCP 的产品边界。
- 安全默认值。

## 迁移心智模型

从 Claude Code 迁移到 Codex 时，可以这样对应：

- `CLAUDE.md` → `AGENTS.md`。
- `.claude/settings.local.json` → `~/.codex/config.toml` 的脱敏模板。
- `/review` 工作流 → `codex review` 或 prompt 配方。
- Hooks → 先用外部脚本/CI/MCP/Plugins 表达，避免假设 Codex 有完全相同机制。
- 权限 allowlist → sandbox + approval + 工作目录边界。

## 仓库协作建议

- 两个仓库互相链接，不共享同一 README。
- 每个仓库只写本产品可验证的命令。
- 共通方法论可以抽象成独立文章，但示例必须分别适配。
