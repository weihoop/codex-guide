# Changelog

## 0.1.2 - 2026-05-28

### 改进

- 新增 `AGENTS.global.md`，作为 `~/.codex/AGENTS.md` 的全局指令最佳实践模板。
- 优化 `AGENTS.template.md`，改为更实用的中文项目级模板，补充命令表、工作原则、安全边界和完成标准。
- 安装脚本会在缺少 `~/.codex/AGENTS.md` 时初始化全局指令；已有全局指令会保留不覆盖。
- 文档补充 Codex 全局 `AGENTS.md` 与项目级 `AGENTS.md` 的配置层次。
- 新增模型与推理强度选择指南，覆盖 `low` / `medium`、`5.4` / `5.5` 和高影响操作建议。

## 0.1.1 - 2026-05-05

### 修复

- 安装脚本默认改为 `rules-only`，保留现有 `~/.codex/config.toml`，避免覆盖用户自定义 provider、模型和项目 trust 配置。
- 保留 simple/full 覆盖配置选项，供新用户或明确需要重置配置时使用。

## 0.1.0 - 2026-05-05

### 新功能

- 初始化 Codex 中文使用手册、配置模板、Skills 文档和安全指南。
- 新增 Codex execpolicy 权限规则模板，支持常见命令 `allow`、危险命令 `prompt`、破坏性命令 `forbidden`。
- 新增 Codex 配置包安装脚本，支持备份本地配置、交互选择 simple/full、安装 `config.toml`、`rules/default.rules` 和 `AGENTS.template.md`。
- 新增 Release 打包脚本，生成 `codex-config.tar.gz` 与版本化压缩包。

### 验证

- 增加 Markdown 本地链接检查脚本。
- 增加 execpolicy 规则决策检查脚本。
