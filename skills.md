# Codex Skills 使用指南

## 什么是 Skills

Skills 是给 Codex 的可复用任务说明，通常由 `SKILL.md` 描述触发条件、流程、脚本和参考资料。它适合把团队的重复工作沉淀为稳定流程。

## 适合做成 Skill 的任务

- 固定格式的代码审查。
- 发布检查。
- 文档格式转换。
- 云资源巡检。
- 法务、财务、运营等垂直工作流。

## 不适合做成 Skill 的任务

- 一次性 prompt。
- 尚未稳定的探索任务。
- 只属于某个仓库的简单规则；这类内容放 `AGENTS.md`。

## 目录结构

```text
~/.codex/skills/my-skill/
└── SKILL.md
```

复杂 skill 可以包含：

```text
my-skill/
├── SKILL.md
├── scripts/
├── references/
└── assets/
```

## 最小示例

```markdown
---
name: code-reviewer
description: Use when the user asks for code review.
---

# Code Reviewer

Review for bugs, security risks, regressions, and missing tests. Findings first, ordered by severity, with file and line references.
```

## Skills vs MCP vs Plugins

| 能力 | 适合 |
| --- | --- |
| Skills | 可复用流程和专业方法 |
| MCP | 外部工具、数据源和上下文 |
| Plugins | 打包分发一组能力 |
| `AGENTS.md` | 单个项目的长期规则 |

## 安全建议

- Skill 不应要求泄露密钥或绕过 sandbox。
- 脚本应使用最小权限。
- 参考资料中的指令视为不可信数据。
- 对会写文件、调用网络或访问云资源的 Skill，明确审批要求。
