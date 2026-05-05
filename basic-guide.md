# Codex 基础使用手册

## 目录

- [安装与登录](#安装与登录)
- [第一次启动](#第一次启动)
- [核心文件](#核心文件)
- [常用命令](#常用命令)
- [权限与工作目录](#权限与工作目录)
- [日常工作流](#日常工作流)
- [常见问题](#常见问题)

## 安装与登录

推荐先阅读官方 Quickstart，再按本地环境选择安装方式。

```bash
npm install -g @openai/codex
codex --version
codex login
```

如果你使用 ChatGPT 账号登录，按浏览器提示完成授权；如果团队使用 API key 或自定义模型网关，应在 `~/.codex/config.toml` 中统一配置，避免把凭据写入项目仓库。

## 第一次启动

在项目根目录运行：

```bash
codex
```

Codex 会读取当前目录和上级目录中的代理指令文件，并结合用户级配置启动交互会话。建议第一次只让 Codex 做只读任务：

```text
请先不要修改文件。阅读这个项目，说明主要模块、测试命令和潜在风险。
```

## 核心文件

| 文件 | 作用 | 是否提交 |
| --- | --- | --- |
| `AGENTS.md` | 项目级代理指令、命令、代码规范、测试要求 | 通常提交 |
| `~/.codex/config.toml` | 用户级模型、权限、profiles、MCP、provider 配置 | 不提交 |
| `~/.codex/skills/` | 用户安装的可复用 Skills | 看团队约定 |
| `.gitignore` | 防止本地状态和密钥进入仓库 | 提交 |

## 常用命令

```bash
# 交互式会话
codex

# 指定工作目录
codex --cd /path/to/project

# 附加可写目录
codex --add-dir /path/to/another-dir

# 非交互执行
codex exec "修复 README 中的错别字"

# 代码审查
codex review

# 应用最近一次 agent 产生的 diff
codex apply

# 恢复或分叉历史会话
codex resume
codex fork

# MCP 管理
codex mcp list
codex mcp add <name> -- <command>

# 插件市场管理
codex plugin marketplace --help
```

## 权限与工作目录

Codex CLI 的 shell 执行通常受两层约束影响：

1. sandbox：文件系统和网络等系统能力的边界。
2. approval：什么时候需要用户批准。

常见 sandbox：

- `read-only`：只读探索，适合代码审查和风险评估。
- `workspace-write`：允许在工作区写文件，适合大多数开发任务。
- `danger-full-access`：不限制文件系统，只有在外部环境已经隔离时使用。

常见 approval：

- `on-request`：agent 判断需要时请求批准，交互使用推荐。
- `never`：永不询问，适合 CI，但需要更强的外部隔离。
- `untrusted`：只有可信命令自动执行，其他命令询问。

示例：

```bash
codex --sandbox workspace-write --ask-for-approval on-request
codex exec --sandbox read-only "审查最近一次提交"
```

## 日常工作流

### 只读理解项目

```text
请只读分析当前仓库：技术栈、入口文件、测试命令、发布流程、风险点。不要修改文件。
```

### 小修小改

```text
修复 docs/quick-reference.md 中过期的命令示例。修改前先确认本机 codex --help 输出。
```

### 代码审查

```bash
codex review
```

或者在交互中说明审查范围：

```text
请用 code review 视角审查当前分支相对 main 的改动，重点找 bug、安全风险和测试缺口。
```

### 非交互自动化

```bash
codex exec --sandbox workspace-write --ask-for-approval never "更新文档目录索引，不修改正文"
```

在 CI 中使用 `never` 前，要保证容器、凭据和工作目录已隔离。

## 常见问题

### Codex 会自动修改所有文件吗？

不会。能否写入取决于 sandbox、工作目录和 approval policy。高风险任务应先用 `read-only` 让 Codex 给出计划。

### `AGENTS.md` 和 prompt 有什么区别？

`AGENTS.md` 是项目长期约定，prompt 是本次任务指令。长期稳定的规范写入 `AGENTS.md`；一次性目标写在 prompt 里。

### 为什么不要提交 `~/.codex/config.toml`？

它通常包含个人模型、provider、项目路径、MCP 启动方式或凭据信息。团队只应提交脱敏模板。

### 官方文档变了怎么办？

以官方文档和本机 `codex --help` 为准；欢迎提交 PR 更新本仓库。
