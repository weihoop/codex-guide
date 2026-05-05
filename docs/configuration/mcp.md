# MCP 集成

MCP 让 Codex 连接外部工具和上下文。

## 常用命令

```bash
codex mcp list
codex mcp add <name> -- <command>
codex mcp get <name>
codex mcp remove <name>
codex mcp login <name>
codex mcp logout <name>
```

## 设计原则

- 最小权限。
- 只读优先。
- 凭据使用环境变量。
- 在 `AGENTS.md` 中说明 MCP 的用途和限制。

## 示例

```bash
codex mcp add docs -- npx -y @modelcontextprotocol/server-filesystem ./docs
```

这类文件系统 MCP 只应暴露任务所需目录。
