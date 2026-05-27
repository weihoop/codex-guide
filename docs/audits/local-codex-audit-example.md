# 本机 Codex 配置审计示例

> 生成时间：2026-05-28。本文是个人机器审计示例，只记录配置结构、风险判断和脱敏摘要，不包含 token、私钥、登录文件、会话历史或真实凭据。

## 总体结论

本机 Codex 已具备完整可用环境：

- 全局 `~/.codex/AGENTS.md` 已完善，并和仓库 `config-templates/AGENTS.global.md` 保持一致。
- `~/.codex/config.toml` 已配置自定义 provider、默认模型和项目 trust 记录。
- `~/.codex/rules/default.rules` 已存在，但当前更接近 relaxed 策略，适合个人熟悉环境，不适合直接作为团队默认。
- `~/.codex/skills/` 已安装或链接 78 个可识别 Skills，覆盖官方系统技能、Superpowers、文档/图片/发布/运维/法律等场景。
- 公开仓库不包含本机 Codex runtime、认证文件、历史、sqlite 日志或真实密钥。

## 核心文件

| 文件 | 状态 | 说明 |
| --- | --- | --- |
| `~/.codex/AGENTS.md` | 已存在 | Codex 全局长期指令，已落地中文、工程/运维、安全和完成前自检规则 |
| `~/.codex/AGENTS.global.md` | 已存在 | 全局模板副本，用于和仓库模板对齐 |
| `~/.codex/AGENTS.template.md` | 已存在 | 项目级 `AGENTS.md` 模板 |
| `~/.codex/config.toml` | 已存在 | 个人配置，包含 provider、模型、项目 trust，本文件不得公开提交 |
| `~/.codex/rules/default.rules` | 已存在 | execpolicy 规则，当前偏宽松 |
| `~/.codex/skills/` | 已存在 | 已安装/链接 Skills |

## AGENTS.md 状态

全局 `AGENTS.md` 已包含以下核心规则：

- 默认简体中文回复。
- 默认工程和运维场景工作模式。
- Shell 默认用 `bash script.sh`，Python 默认用 `python3 script.py`。
- 遵循“先想后写、能简则简、精准修改、目标驱动、持续校验”。
- 不主动 commit、push、rebase，除非用户明确要求。
- 不使用会丢失改动的 Git 命令，除非用户明确批准。
- 不提交密钥、token、私钥、`.env`、日志、缓存、历史记录、会话或个人配置。
- 生产、云资源、数据库、IAM、DNS、证书、删除/覆盖操作前，先说明影响范围、回滚方案和验证方式。

建议：如果后续经常执行云资源、堡垒机、VPN、生产数据库操作，可以把“高危操作二次确认清单”进一步写硬。

## config.toml 脱敏摘要

当前配置重点：

- 默认模型：`gpt-5.5`
- 推理强度：`medium`
- 默认 provider：自定义 provider `crs`
- 包含多个 `[projects."..."]` 项目记录，里面有本机绝对路径。

风险判断：

- `~/.codex/config.toml` 是个人配置，不应提交公开仓库。
- 公开文档只能使用 `config-templates/config.simple.toml` 和 `config-templates/config.full.toml` 这类脱敏模板。
- 如果要给团队分发配置，必须删除真实 provider、token、本机路径和个人项目 trust 记录。

## execpolicy 规则状态

当前 `~/.codex/rules/default.rules` 文件头显示为 relaxed 规则，目标是减少确认次数。

已阻止的机器级高危操作包括：

- `rm -rf /`
- `rm -rf ~`
- `dd`
- `mkfs`
- 抹盘类命令

需要注意：当前规则允许较多敏感命令，例如：

- `git push`
- `git reset`
- `git clean`
- `npm install` / `pip install`
- `docker`
- `kubectl`
- `terraform plan`
- `ssh`
- `sudo`

建议：

- 个人熟悉机器可以继续使用 relaxed 规则。
- 新项目、团队模板、生产运维场景建议使用保守规则。
- 即使规则允许，也应让 `AGENTS.md` 要求高危操作先说明影响、回滚和验证。

## Skills 安装状态

`find -L ~/.codex/skills -name SKILL.md` 识别到 78 个 Skills。主要来源：

- `~/.codex/skills/.system/`：Codex 系统技能。
- `~/.claude/skills/...`：通过 symlink 复用的本机技能。
- `~/.agents/skills/...`：通过 symlink 复用的 agent 技能。
- `~/.codex/skills/baidu-search`：本地 Codex skill。

### 核心已安装 Skills

| 类别 | 已安装示例 | 用途 |
| --- | --- | --- |
| 官方/系统 | `openai-docs`、`skill-installer`、`skill-creator`、`plugin-creator`、`imagegen` | 官方文档、安装/创建 Skills、插件、图像生成 |
| Superpowers | `using-superpowers`、`test-driven-development`、`systematic-debugging`、`verification-before-completion`、`writing-plans` | TDD、调试、验证、计划、代码审查流程 |
| Release | `release-skills` | 版本、changelog、tag、GitHub Release 流程 |
| 内容生产 | `baoyu-*`、`giggle-*`、`kie-*` | 图片、海报、视频、图文、发布 |
| 法律/文档 | `contract-review`、`legal-doc-draft`、`case-summary`、`evidence-organize` | 法律文书和证据整理 |
| 运维 | `aliyun-*`、`jumpserver-ops`、`netbird-ops`、`github-creator` | 云资源、堡垒机、VPN、GitHub 仓库 |
| 数据/格式 | `image-to-excel`、`image-to-word`、`privacy-blur`、`notebooklm` | 表格识别、文档转换、隐私打码、知识库查询 |

### 已安装环境的优势

- 对开发流程已经有 TDD、调试、review、verification、release 支撑。
- 对中文文档、图片、法律、运维场景覆盖很广。
- 系统自带 `skill-installer`，后续可以从 OpenAI curated skills 安装补充能力。

### 风险点

- 很多 Skills 是 symlink 到其他目录，不适合作为团队公开配置直接复制。
- `baoyu-danger-*`、发帖、云资源、堡垒机、VPN、生成视频等 Skills 能力较强，应按需使用，不建议团队默认全局启用。
- 第三方 Skills 安装前需要审查脚本、网络访问、凭据读取和输出路径。

## 还能补装的 Codex Skills

基于 OpenAI curated 列表和 `npx skills find` 搜索，本机还能考虑补装以下方向。

### 优先推荐

| Skill | 来源 | 价值 | 安装建议 |
| --- | --- | --- | --- |
| `playwright` | OpenAI curated | 浏览器自动化、端到端测试、前端验证 | 前端/网页项目建议安装 |
| `screenshot` | OpenAI curated | 截图读取、UI 问题描述、视觉验证 | 前端和文档截图场景建议安装 |
| `security-best-practices` | OpenAI curated | 安全检查、敏感信息和风险审查 | 公开库和团队项目建议安装 |
| `security-threat-model` | OpenAI curated | 威胁建模，适合上线前安全评审 | 涉及公网、登录、支付、云资源时安装 |
| `gh-fix-ci` | OpenAI curated | 修 GitHub CI 失败 | GitHub Actions 项目建议安装 |
| `gh-address-comments` | OpenAI curated | 处理 PR review comments | 团队协作/开源项目建议安装 |
| `define-goal` | OpenAI curated | 长任务目标定义 | 和当前 `/goal` 工作流互补，可评估 |
| `migrate-to-codex` | OpenAI curated | 从其他 coding agent 迁移 | 对本仓库迁移文档有帮助 |

### 前端/React 可选

| Skill | 来源 | 价值 | 安装建议 |
| --- | --- | --- | --- |
| `vercel-labs/agent-skills@vercel-react-best-practices` | skills.sh | React/Next.js 最佳实践审查 | 前端项目高价值，建议先审查后安装 |
| `vercel-labs/agent-skills@vercel-react-native-skills` | skills.sh | React Native 规则 | 做移动端时安装 |
| `vercel-labs/agent-skills@vercel-react-view-transitions` | skills.sh | View Transitions 交互 | 需要现代前端动效时安装 |
| `currents-dev/playwright-best-practices-skill@playwright-best-practices` | skills.sh | Playwright 测试最佳实践 | 如果大量写 E2E，建议评估 |
| `microsoft/playwright-cli@playwright-cli` | skills.sh | Playwright CLI 使用 | 可和 OpenAI curated `playwright` 二选一评估 |

### 长任务/上下文可选

| Skill | 来源 | 价值 | 安装建议 |
| --- | --- | --- | --- |
| `othmanadi/planning-with-files@planning-with-files-zh` | skills.sh | 中文文件化计划 | 长项目非常适合，建议优先评估 |
| `addyosmani/agent-skills@context-engineering` | skills.sh | 上下文工程 | 适合复杂需求、长上下文项目 |
| `neolabhq/context-engineering-kit@sdd:plan` | skills.sh | 规格驱动计划 | 如果团队要推 SPEC/SDD，可评估 |
| `neolabhq/context-engineering-kit@sdd:implement` | skills.sh | 规格驱动实现 | 与上一个配套使用 |

### 服务集成可选

| Skill | 来源 | 价值 | 注意事项 |
| --- | --- | --- | --- |
| `sentry` | OpenAI curated | 线上错误分析 | 需要 Sentry token，必须最小权限 |
| `linear` | OpenAI curated | 需求/任务管理 | 需要外部账号和 token |
| `notion-*` | OpenAI curated | 知识库、会议、需求到实现 | 注意文档权限和隐私 |
| `vercel-deploy` / `netlify-deploy` / `cloudflare-deploy` / `render-deploy` | OpenAI curated | 部署工作流 | 需要明确环境、项目和审批边界 |
| `figma-*` | OpenAI curated | 设计稿、设计系统、实现设计 | 适合前端设计协作，需控制 Figma 权限 |

## 推荐安装顺序

建议不要一次装满，按以下顺序小步验证：

1. `security-best-practices`：先加强公开库和团队项目安全审查。
2. `playwright` + `screenshot`：补足前端/浏览器验证能力。
3. `gh-fix-ci` + `gh-address-comments`：提升 GitHub 协作效率。
4. `planning-with-files-zh`：长任务、多人协作和阶段性计划。
5. `vercel-react-best-practices`：如果近期做 React/Next.js，再安装。
6. `sentry` / `linear` / `notion` / deploy 类：只在需要外部服务时安装，并先配置最小权限。

## 安装命令示例

OpenAI curated skills 使用 `skill-installer`：

```bash
python3 ~/.codex/skills/.system/skill-installer/scripts/install-skill-from-github.py \
  --repo openai/skills \
  --path skills/.curated/security-best-practices \
  --path skills/.curated/playwright \
  --path skills/.curated/screenshot
```

skills.sh 生态使用 `npx skills`：

```bash
npx skills add othmanadi/planning-with-files@planning-with-files-zh -g -y
npx skills add vercel-labs/agent-skills@vercel-react-best-practices -g -y
npx skills add addyosmani/agent-skills@context-engineering -g -y
```

安装第三方 Skills 后，建议重启 Codex，并用低风险 demo 任务验证触发条件和输出质量。

## 公开仓库注意事项

本仓库可以公开，但不要提交以下本机文件：

- `~/.codex/config.toml`
- `~/.codex/auth.json`
- `~/.codex/history.jsonl`
- `~/.codex/sessions/`
- `~/.codex/logs_*.sqlite*`
- `~/.codex/state_*.sqlite*`
- `~/.codex/goals_*.sqlite*`
- 任何真实 API key、token、私钥、`.env` 或私有 provider 配置

`.gitignore` 已覆盖上述主要运行态文件；如果从其他目录复制文件到仓库，仍需重新扫描。
