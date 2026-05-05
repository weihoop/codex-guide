# Changelog

## 0.1.0 - 2026-05-05

### 新功能

- 初始化 Codex 中文使用手册、配置模板、Skills 文档和安全指南。
- 新增 Codex execpolicy 权限规则模板，支持常见命令 `allow`、危险命令 `prompt`、破坏性命令 `forbidden`。
- 新增 Codex 配置包安装脚本，支持备份本地配置、交互选择 simple/full、安装 `config.toml`、`rules/default.rules` 和 `AGENTS.template.md`。
- 新增 Release 打包脚本，生成 `codex-config.tar.gz` 与版本化压缩包。

### 验证

- 增加 Markdown 本地链接检查脚本。
- 增加 execpolicy 规则决策检查脚本。
