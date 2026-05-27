# ChatGPT Codex 中文使用手册

<div align="center">

**面向中文开发者的 OpenAI Codex / Codex CLI / Codex Cloud / Codex IDE 使用指南**

[📚 完整文档索引](docs/INDEX.md) · [🚀 快速开始](docs/getting-started/README.md) · [⚙️ 配置模板](config-templates/README.md) · [🧩 Skills](skills/README.md) · [🔐 安全指南](security-guide.md)

</div>

---

## 关于本项目

`codex-guide` 是一个非官方中文文档仓库，目标是帮助开发者系统掌握 ChatGPT Codex 的日常使用、项目配置、安全权限、自动化工作流和团队实践。

它不是 `claude-code-guide` 的简单复制版。两个产品都属于 agentic coding 工具，但 Codex 的关键心智模型是：

- `AGENTS.md`：项目级代理指令文件。
- `~/.codex/config.toml`：用户级配置、模型、sandbox、approval、MCP、profiles。
- Codex CLI：终端交互、非交互执行、review、apply、resume/fork、sandbox、MCP 和 plugin 管理。
- Codex Cloud / App / IDE：适合云端任务、桌面和编辑器集成。
- Skills / Plugins / MCP：扩展能力的三条路径，分别适合可复用工作流、产品级扩展和外部工具上下文。

## 快速开始

```bash
# 安装 Codex CLI（以官方文档为准）
npm install -g @openai/codex

# 登录
codex login

# 在项目目录启动
codex

# 非交互执行一次任务
codex exec "阅读项目并总结主要模块"
```

如果你的环境已经安装 Codex，可以先确认版本：

```bash
codex --version
codex --help
```

本仓库内容按 `codex-cli 0.128.0` 的命令帮助和 OpenAI 官方文档整理；如果命令或配置发生变化，请优先以官方文档和本机 `codex --help` 为准。


### 一键安装 Codex 配置包

Release 会提供 `codex-config.tar.gz`，包含 `config.toml` 模板、execpolicy rules、全局 `AGENTS.global.md` 和项目级 `AGENTS.template.md`。

```bash
# 安装最新 Release
wget https://github.com/weihoop/codex-guide/releases/latest/download/codex-config.tar.gz
tar -xzf codex-config.tar.gz
cd codex-config
bash install.sh
```

如果要固定版本，可以下载版本化资产：

```bash
wget https://github.com/weihoop/codex-guide/releases/download/v0.1.3/codex-config-v0.1.3.tar.gz
tar -xzf codex-config-v0.1.3.tar.gz
cd codex-config
bash install.sh
```

安装脚本会先备份 `~/.codex/config.toml`、`~/.codex/rules/` 和 AGENTS 指令/模板；默认选择 `rules-only`，保留现有 `config.toml`，只更新权限规则和 AGENTS 模板。如果 `~/.codex/AGENTS.md` 不存在，会用 `AGENTS.global.md` 初始化；如果已存在则保留不覆盖。默认策略允许常见本地命令，`rm`、`git push`、依赖安装等敏感操作会询问，系统级危险命令会阻止。

配置包内容：

- `config.simple.toml` / `config.full.toml`：精简版和完整版配置模板。
- `rules/default.rules` / `rules/relaxed.rules`：保守和宽松两套 execpolicy 权限规则。
- `AGENTS.global.md`：全局代理指令模板，可初始化为 `~/.codex/AGENTS.md`。
- `AGENTS.template.md`：项目级代理指令模板。
- `requirements.example.toml`：团队约束示例。
- `install.sh`：交互式安装脚本，支持备份、覆盖提醒和安装模式选择。

支持平台：macOS、Linux。

## 文档入口

| 文档 | 说明 | 适合人群 |
| --- | --- | --- |
| [基础使用手册](basic-guide.md) | 安装、登录、启动、常用命令、模式和项目指令 | 新手 |
| [进阶使用手册](advanced-guide.md) | MCP、Plugins、Skills、profiles、非交互自动化 | 进阶用户 |
| [最佳实践](best-practices.md) | 上下文管理、任务拆分、代码审查、团队协作 | 所有人 |
| [安全使用手册](security-guide.md) | sandbox、approval、敏感信息、权限边界 | 必读 |
| [Skills 使用指南](skills.md) | Codex Skills 的定位、安装、创建和治理 | 重度用户 |
| [完整文档索引](docs/INDEX.md) | 按场景和难度查找文档 | 所有人 |
| [快速参考卡](docs/quick-reference.md) | 命令、配置、文件和工作流速查 | 日常使用 |
| [模型与推理强度选择](docs/model-selection.md) | low/medium、5.4/5.5 与高影响操作推荐配置 | 运维、部署、云资源和编码用户 |
| [推荐 Skills 与工作流](docs/skills/recommended-skills.md) | 按场景选择 Skills、MCP 和团队工作流 | 进阶用户、团队 |
| [Codex 高效使用 10 条](docs/workflows/codex-productivity-tips.md) | prompt、goal、plan、截图、测试闭环和安全模式 | 日常使用 |
| [本机 Codex 配置审计示例](docs/audits/local-codex-audit-example.md) | AGENTS、config、rules、Skills 与补装建议的脱敏审计 | 个人环境维护 |
| [迁移对照](docs/codex-vs-claude-code.md) | Codex 与另一类 coding agent 工具的差异对照 | 迁移用户 |

## 推荐学习路径

1. 阅读 [安装与登录](docs/getting-started/installation.md)，完成 Codex CLI 安装。
2. 可参考 [全局 AGENTS 模板](config-templates/AGENTS.global.md) 初始化 `~/.codex/AGENTS.md`，再复制 [项目 AGENTS 模板](config-templates/AGENTS.template.md) 到项目根目录并改写项目约定。
3. 使用 [简单配置模板](config-templates/config.simple.toml) 初始化 `~/.codex/config.toml`。
4. 阅读 [权限与沙箱](docs/configuration/permissions-and-sandbox.md) 和 [Execpolicy 权限规则](docs/configuration/execpolicy-rules.md)，理解 sandbox、approval 与 allow/prompt/forbidden 的配合。
5. 按 [快速参考卡](docs/quick-reference.md) 跑一次 `codex review`、`codex exec`、`codex apply` 的闭环。

## 仓库结构

```text
.
├── README.md
├── basic-guide.md
├── advanced-guide.md
├── best-practices.md
├── security-guide.md
├── skills.md
├── AGENTS.md
├── config-templates/
├── docs/
├── skills/
└── scripts/
```

## 官方资源

- OpenAI Codex 文档：https://developers.openai.com/codex
- Quickstart：https://developers.openai.com/codex/quickstart
- CLI reference：https://developers.openai.com/codex/cli/reference
- Config reference：https://developers.openai.com/codex/config-reference
- AGENTS.md：https://developers.openai.com/codex/guides/agents-md
- Skills：https://developers.openai.com/codex/skills
- Plugins：https://developers.openai.com/codex/plugins
- Agent approvals and security：https://developers.openai.com/codex/agent-approvals-security
- GitHub： https://github.com/openai/codex

## 贡献建议

- 新增文档时同步更新 `docs/INDEX.md`。
- 修改命令或配置示例前，先用 `codex --help` 或官方文档确认。
- 不提交个人 `~/.codex` 目录、认证文件、历史记录、私有 provider 或本机路径。
- 如果内容来自官方文档，请用自己的中文解释重写，并在文末附链接。

## License

MIT
