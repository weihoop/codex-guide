# Codex Plugins

Plugins 适合把一组能力打包分发，例如 skills、命令、MCP 配置、说明文档和资源文件。

## 命令入口

```bash
codex plugin --help
codex plugin marketplace --help
```

## 什么时候用 Plugin

- 团队要统一安装一组能力。
- 单个 Skill 不够，需要多个资源文件或脚本。
- 需要版本、市场或分发机制。

## 什么时候不用 Plugin

- 只是一个简单 prompt 模板。
- 只是某个项目的 `AGENTS.md` 规则。
- 还没有稳定的流程，先写文档或 Skill 更合适。
