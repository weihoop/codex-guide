# Codex 配置模板

## 文件说明

| 文件 | 说明 |
| --- | --- |
| `config.simple.toml` | 保守入门配置 |
| `config.full.toml` | profiles、MCP、provider 占位示例 |
| `AGENTS.template.md` | 项目级指令模板 |
| `requirements.example.toml` | 团队约束示例 |
| `install.sh` | 交互式安装模板 |

## 安装

```bash
bash config-templates/install.sh
```

脚本会备份现有 `~/.codex/config.toml`，再复制简单模板。
