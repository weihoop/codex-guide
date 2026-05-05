# Codex 配置总览

Codex 的用户配置通常位于：

```text
~/.codex/config.toml
```

项目级长期指令通常写在：

```text
AGENTS.md
```

## 推荐配置层次

1. 用户级 `config.toml`：模型、provider、sandbox、approval、profiles、MCP。
2. 项目级 `AGENTS.md`：项目命令、风格、测试、安全边界。
3. 本次 prompt：当前任务目标和验收标准。

## 模板

- [简单模板](../../config-templates/config.simple.toml)
- [完整模板](../../config-templates/config.full.toml)
- [AGENTS 模板](../../config-templates/AGENTS.template.md)

## 命令行覆盖

```bash
codex -c model='"gpt-5.4"'
codex -c shell_environment_policy.inherit=all
codex -p dev
```

命令行覆盖适合临时实验，不建议把复杂配置长期写在启动命令里。
