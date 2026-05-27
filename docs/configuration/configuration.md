# Codex 配置总览

Codex 的用户配置通常位于：

```text
~/.codex/config.toml
```

全局长期指令可写在：

```text
~/.codex/AGENTS.md
```

项目级长期指令通常写在：

```text
AGENTS.md
```

## 推荐配置层次

1. 用户级 `config.toml`：模型、provider、sandbox、approval、profiles、MCP。
2. 全局 `~/.codex/AGENTS.md`：个人长期偏好、通用安全边界和工作习惯。
3. 项目级 `AGENTS.md`：项目命令、风格、测试、安全边界。
4. 本次 prompt：当前任务目标和验收标准。

当前已验证的公开用法是：全局长期偏好写入 `~/.codex/AGENTS.md`，项目长期约定写入仓库内 `AGENTS.md`。更具体的项目级指令和本次用户 prompt 应覆盖全局偏好。

## 模板

- [简单模板](../../config-templates/config.simple.toml)
- [完整模板](../../config-templates/config.full.toml)
- [全局 AGENTS 模板](../../config-templates/AGENTS.global.md)
- [项目 AGENTS 模板](../../config-templates/AGENTS.template.md)

## 命令行覆盖

```bash
codex -c model='"gpt-5.4"'
codex -c shell_environment_policy.inherit=all
codex -p dev
```

命令行覆盖适合临时实验，不建议把复杂配置长期写在启动命令里。
