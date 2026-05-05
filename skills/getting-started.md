# Skills 入门

Skill 的核心价值是让 Codex 在特定任务中自动采用稳定方法，而不是每次都重新解释流程。

## 第一个 Skill

```text
~/.codex/skills/code-reviewer/SKILL.md
```

写入：

```markdown
---
name: code-reviewer
description: Use when reviewing code changes.
---

# Code Reviewer

Find bugs, security risks, regressions, and missing tests. Output findings first with file and line references.
```
